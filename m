Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3952CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1220E6B008C; Mon, 22 Jun 2026 14:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9D36B0093; Mon, 22 Jun 2026 14:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CBE6B008C; Mon, 22 Jun 2026 14:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B69B86B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16D2812027F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:04 +0000 (UTC)
X-FDA: 84908435808.02.E5C9663
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5B023100009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iTo3eHcH;
	spf=pass (imf14.hostedemail.com: domain of 3nIM5agkKCOEWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3nIM5agkKCOEWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154141;
	b=ZMf6HVnccNzyDXPL3L+t9G7h9fPw8VG1GfuKCtelWoaWEu+FID6VmV2rU5Tee2zj+hMZS2
	zSJpb9yTT46edNbEQjaekpSPzB/wZoB6q3mR25acSOLffS7GdNhLG3eZs+BZUjlcYXVHJL
	B6Uy8voNvCSz3VgzrCksCVfVrJpHDSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OEWwFi6TggeUgPIb5O1s/aY8eVgW9dSMubR6vHRGBr0=;
	b=fssDO058Nqit4UcnDg1V+SHkT7RTsQ59DgCO0sI9FOgzyEX/xcIR4jDyPEM92bpTSHUZ8Y
	0SN/twiCU+SBMM7MDiIE6V4DJcl3+Seu9kSN0Iqq9D+3v/qlHyfekGvOFiHBnbP9CJqmGf
	clboMmbn77WuUB9fyqFQ4A7o62uYhd0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iTo3eHcH;
	spf=pass (imf14.hostedemail.com: domain of 3nIM5agkKCOEWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3nIM5agkKCOEWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b5d2e394so31106855e9.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154141; x=1782758941; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OEWwFi6TggeUgPIb5O1s/aY8eVgW9dSMubR6vHRGBr0=;
        b=iTo3eHcHIwXLojVrzbtozQMvWCIFzcckKMgGF6pO3SNSU4+ayfMFZwqZVLeP+ZZolm
         vj+N7ZWBoxgRKPynmaAnncOqHtfKvvVpog6PobHgzr4HfyrkOMraMyyIXtNpkJS4VBbX
         ncdB8AVS+92bIOmosqosDD16uU5XchgQeuV/R2vzoQ0LiFgsTXhPh+oMT+TQ34Dk2a+e
         4fN9qKofQO3NMRwbkxTW5VNka2B+ukQuwRddMtuyO4qwTXP//Vtw+njyBd8WGd7GXEG9
         kfdcrSUN6Yvda6kiQvJszlm3Kd+YPtapHJ/aDreVn7j/s9icPh10Jh18CAD2VxJREXfz
         9XJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154141; x=1782758941;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OEWwFi6TggeUgPIb5O1s/aY8eVgW9dSMubR6vHRGBr0=;
        b=aU0AqaMD/oX7nCChwjrqzJ3yXpKo2SPD4RBdSSNOGuUocH9+RJtpMB6x226v6hE7cd
         4lMmtxanGVXN6dXaf8Hy2kJ9iHY/21KnWm3kqdqHEOFmUGVhPKgMiw0xuSGbQ36jTq2p
         skNA+SeHLet3Yh4U1dpR4SoZL6b37hsIZqUfJWEUBfLKRv0kV16QBLyzTKbnAmlCS/FY
         /jRFLSyUq+5cH1x4WgXrJFTfSZWMBiYsR3Tztq5lrQ5caKlHSwMTaGUn+YtmBE8ogKIY
         CSKW9zPpHhw9aewvcVlA5+EzgxMFxn0iijEBCXMwd7BFSk1DfOgfCRXiZ8vVDlnsbwOS
         fKHQ==
X-Forwarded-Encrypted: i=1; AFNElJ8JbcTGzvaGQt70VW/DzVx6VWIP2BEBubp/94kMgp5JafRYkGy1hLnwLJbgY39wDvIZuOmh7wpV4w==@kvack.org
X-Gm-Message-State: AOJu0YzAs6nrBQC+lkKx6F5rf934D4NINLGlzOyTe/1gNK/Z3uWpmAn/
	CGhYIbonlT5/tysUAwcYH2uXgxR9uk34b0u6cFwXjpGEe95LbzRDJi+A3R0OEzF8IxO3qZHG6Ia
	m7Muz4VufCevogSaWkA==
X-Received: from wmnj21.prod.google.com ([2002:a05:600c:755:b0:492:4a9f:3d5a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c059:10b0:490:bb45:79da with SMTP id 5b1f17b1804b1-49240e427f0mr195668185e9.13.1782154140754;
 Mon, 22 Jun 2026 11:49:00 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:42 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-1-tarunsahu@google.com>
Subject: [PATCH v3 0/9] liveupdate: kvm: guest_memfd preservation
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5B023100009
X-Stat-Signature: anajqnqy9sprxu19itux9zf5f77j4fyf
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782154142-940351
X-HE-Meta: U2FsdGVkX18r2vmlfwuvN3Vf9kEuTO0No9vcNme19tLvzFu31VDAqnfhwXbrup/8Wq0ZgeLZ3iMuEQsRVcviJydu82TkI4SGvVELDcjnnzyHcDFngDHglO9orVEoDp+ewfVD/kj7KWOfZ4v3kt5/DrNc4/olmJaKcjaXhjGdtp2bg4xY58KfBzcR+cFe9mdr2VP6nuhtZcIR5vsTMimYRwiJL7dcIpOxL3wKrFO+fdtcJa0Ol7+VhizSv7hE6g5wVpiMD2p+HWihFX/W1o2MuoTr0z1IZX2nyG/K3R3kuGVauMNjTx3dWRP0pXqisjKiX+9jx73HMvD97kpEScKfsQ6KEgi5DBgt9o/dBpk7zdCX6CJdk613sgFV4kUrAcevP//0QS5ys6U7yQTARwDC4j+0IDdKm9nMVISSOVQ3tnFN1IrKeiOMXoWmWu8Bi4Vh93uBphNCWTOsYa6qw9jFrqEYEWfQnJEVChjUo8v1ZH4sDsdLPZC3vHcfs1mouPEqk+rnEYkSBXLKSRJoxTR4dajvYBVmbEbCSqvHkUlAwN4m96O2Hf28YtWrO+z6FqtetH+7GzGQ3RLOn6rwObxVH6yxM1BuUwGak5PTY6SuSn9CA4YPb5MbQuvdSDLJQ8idfHqLMQOPtfdWNXkBpEUvEDQWOnq/gc0rRfYM0ovswwL+tc2iau960vX6URJ55E52LwOdS1RgL346HxBWjykvEK9gPmkfV5RgYviRFCesCPf4bByqm1YUd1rj28utG1jkxjJgv4YUCTTF/KY1KzIY2eBVVp2S4OJ+WoAkX5CW52GiSoV73HXDrSDomhMpeLOnCYNGxxzGDqkMHFS1GesgccsrIq+5d1qXdy20lVWh3tSIl/56cIQUstp48D9CKmE3k3lexPQ7N8vBCHJAYvW5KI+U//MKVZ/hL59E8VRNG6lyc+5FJhpNeD3bEESJR6aofQ2CIJDnhpwXiKaGDYE
 hp/uj7vQ
 QAJhpNph13aq8oFL6+zUV1OklLeYbQF68/NbLyM67wq3XvVEfjh3F1kSnVyMCfOFUlCNvvh5weA6L+qheJvEBBwQvXHTQGI1Lwkoji7oVabiJWvPXtl5NANgSMlBQSyq9kKikAsYpfx6IxoUb6/hIc7JQeYvVIj8Bk5TedvtpcOgMVNtWH6ePvFgzpiNulkWqANid6fC4Wwd/V/GxwyppWD3fmm18wa40dccCO2KaMhGT0Kjc3SftU3sG3s41/jQ6Ker5JPSviFWlY5IHSUVsC4u3YybfDccc7QynsGQt0b6I9GWQm2J664HfMjkv0h1mWO5yiSY5/3kUFfEjuBJ2pHgzmCxRKUA9OPZSFYq9zCdE6Mfuw9NfOwfOv29tJqRoo78S5Q9AGyKXGZGDD2yQOIDr1nEe1Upz0VX3GH7v61y1ILxWYpfVzhQoNrrCuns2KUe2qsOCycmU6TU5WSN9rAZIPfwzbDEmnGqkalwQnE1JtIp0csNEsLcxDFhJmnAVzkmYbv/gZqTGcVNai+79VzLNcu2qSNcuACP9zVHkvA8BS8Rib+ZZcheoYW7xm6NkgbmpDVpqaXP2V/OrtAVsI1i9oOqfbOcvHioszttaoKlAZJBtuGEk5u4PplXBtm/2f6rJXzf7Ocr6iq1g3ga5qESyktrBFY50a0sy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,
This is Non-RFC patch series for guest_memfd preservation. After
having multiple discussion across hypervisor liveupdate meeting,
guest_memfd bi-weekly meeting, the design for the basic support of
guest_memfd preservation is final. This series is going to include
guest_memfd which are fully shared and does not support private mem
and backed by PAGE_SIZE pages.

Steps to test:
1. Compile Kernel with CONFIG_LIVEUPDATE_GUEST_MEMFD=y
2. boot kernel with command line: kho=on liveupdate=on
3. run the following kselftest
	$ .selftests/kvm/guest_memfd_preservation_test --stage 1
	$ <kexec> --reuse-cmdline
	$ .selftests/kvm/guest_memfd_preservation_test --stage 2

NOTE: Assert the following:
	$ ls /dev/liveupdate
	$ ls /dev/kvm
	$ dmesg | grep liveupdate # (should have kvm_vm_luo &&
		# guest_memfd_luo handler registered)

The changes are rebased on:
	kvm/next + liveupdate/next (merge) + [3] + [4] + [5]
	Where,
	[3]: luo: conversion of serialized_data to KHOSER_PTR
	[4]: luo: APIs to retrieve file internally from session
	[5]: selftests: liveupdate sefltests library
Here is the github repo:
	https://github.com/tar-unix/linux/tree/gmem-pre

V3 <- RFC V2 [2]
1. Finalize the design
2. resolve sashiko reported bugs
3. Use of KHOSER_PTR instead of raw serialized_data as per [3]

RFC V2 [2] <- RFC V1 [1]
1. Removed mem_attr_array as it is not needed for fully-shared
2. Removed pre-faulted condition
3. Added vm_type preservation for ARM64.
4. Removed liveupdate_get_file_incoming api patch as it is sent
   separately [4] by Samiullah.

[1] https://lore.kernel.org/all/cover.1779080766.git.tarunsahu@google.com/
[2] https://lore.kernel.org/all/c054ba0fb2639932bbe354420d3f4f84cce84905.1780676742.git.tarunsahu@google.com/
[3] https://lore.kernel.org/all/20260622111215.4157974-1-tarunsahu@google.com/
[4] https://lore.kernel.org/all/20260613012521.835490-1-skhawaja@google.com/
[5] https://lore.kernel.org/all/20260612214512.464146-1-vipinsh@google.com/

Tarun Sahu (9):
  liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
  kvm: Prepare core VM structs and helpers for LUO support
  kvm: kvm_luo: Allow kvm preservation with LUO
  kvm: guest_memfd: Move internal definitions and helper to new header
  kvm: guest_memfd: Add support for freezing and unfreezing mappings
  kvm: guest_memfd_luo: add support for guest_memfd preservation
  docs: add documentation for guest_memfd preservation via LUO
  selftests: kvm: Split ____vm_create() to expose init helpers
  selftests: kvm: Add guest_memfd_preservation_test

 Documentation/core-api/liveupdate.rst         |   1 +
 Documentation/liveupdate/vmm.rst              | 107 ++++
 MAINTAINERS                                   |  14 +
 include/linux/kho/abi/kvm.h                   | 106 ++++
 include/linux/kvm_host.h                      |  14 +
 kernel/liveupdate/Kconfig                     |  15 +
 tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
 .../kvm/guest_memfd_preservation_test.c       | 236 +++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  26 +-
 virt/kvm/Makefile.kvm                         |   1 +
 virt/kvm/guest_memfd.c                        | 185 +++++--
 virt/kvm/guest_memfd.h                        |  44 ++
 virt/kvm/guest_memfd_luo.c                    | 497 ++++++++++++++++++
 virt/kvm/kvm_luo.c                            | 195 +++++++
 virt/kvm/kvm_main.c                           |  94 +++-
 virt/kvm/kvm_mm.h                             |  15 +
 17 files changed, 1477 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/liveupdate/vmm.rst
 create mode 100644 include/linux/kho/abi/kvm.h
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c
 create mode 100644 virt/kvm/guest_memfd.h
 create mode 100644 virt/kvm/guest_memfd_luo.c
 create mode 100644 virt/kvm/kvm_luo.c

-- 
2.55.0.rc0.786.g65d90a0328-goog


