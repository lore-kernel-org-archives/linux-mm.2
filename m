Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2176DCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 03:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1D78E0005; Mon,  6 Oct 2025 23:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B7F8E0002; Mon,  6 Oct 2025 23:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123648E0005; Mon,  6 Oct 2025 23:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F331F8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:31:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E3A65B610
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:08 +0000 (UTC)
X-FDA: 83969892216.01.8119735
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id CB6C61A000E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Sq7AvYaA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759807866; a=rsa-sha256;
	cv=none;
	b=yHInMjrqec2fml2kWZol6YFCRXJq8I05aHIJvH71TSpxhm8eQFa4NZZhb7/ApjWKeW1HA5
	yoyE3gpmIT0fAOoxMQ5QmOPDCBswVrgbWc/zZTSBzbRHge45xDzLw387skEtOvdqhD0s3K
	/t+FQlodzZksTqF17O31HBZlMN2OFO8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Sq7AvYaA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759807866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Rjctk86pjCIgeyP/NdtThstP3+9eB+EELMA59nxuFWo=;
	b=yx4PV3daiajonGnVuRYax9cEJlSzmdgCyELbePrpvj+FT3eClQ8ECcAVzfLFOjkvB7YzOi
	APUsY7xpHnh4Ed0btFYLol6xFwwTjG0lEZJpF2mRJtMH6Uo3bxO6OcGI1jGCIYgb7akZkG
	oqkx3K9/32oCwZXhxFXbll/Tx99JqJU=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5aa6b7c085aso6116469137.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 20:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759807866; x=1760412666; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rjctk86pjCIgeyP/NdtThstP3+9eB+EELMA59nxuFWo=;
        b=Sq7AvYaAOjMxTJSZ6sACJpxweayIKV9gKaRqRfUbsA6KYwhgu1E0yccrbvBG8D92B0
         V3f+XQ+6K9A+QUMP1yMG0SHJ0zFcz7PxzvfMrWVGO4NU4ekru6mknG8Pe0aqV60Z66YT
         fmkOz5DqEEDuYyqFn4SyTuP3r+WcHS+uHG1PLdYVrVEzfv81q7Uh4eUOCGu9EKHxetqR
         i+1WiGkUH/sgs+6a3FAkkCQox4xLunQUgMW3w5ibg30tUIibGko1QIbkZq4gwjbMvvtm
         izBCLTTDrUASEee1X7kObE+eSWq4sisn9SKJX5BAjyzPBeIL/jDaLwesnVHarzvbJbvH
         SPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759807866; x=1760412666;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rjctk86pjCIgeyP/NdtThstP3+9eB+EELMA59nxuFWo=;
        b=P59/gR9wLlTEyxXBr98PpQ5gUExUWR/T9hPOL0nKHxv9vLUkz6S6EgDQCJyCPp1rj9
         FOSVw1rafLKCgmm1bFS5cMjbufqG0i1EyxUYABdV5nMIQXz4OqEuCcmTG9MKyEg0Q3VJ
         Qd14i6hrExG/qaTWI8t5MbMMipLPXw/CMycCzSqS1JW7BHM9KWEc4cuFT2ef0b7POPnh
         Wpi+EDq/loqKD5k6iC7ckwahy8uHh7xkGR8a1m2TOvmgA8ZQ+Sb9vdj88kqLrUEAw1FF
         cU10igxiKUK18svcIUBbKbLtrBTHqQGPwoIIgQGlh2PZqXLVVDNjBRyF8ktqf651UThB
         nUEA==
X-Forwarded-Encrypted: i=1; AJvYcCW2/+RfLOSZwP4HfoHrPylY07JnOz+lNlEluUmdDx/O6e1u8QQPr2Qc3/Om37YYYqDOvXyXtH53fg==@kvack.org
X-Gm-Message-State: AOJu0Yxnty9zSSC9kCGTJOVb2yve/uxDSfxrcvZbb/3cvwRwDszIby4g
	q2x2trcIsy3jDvajNOZrzGpVXP0K3ZN3z0Q3y5N+l4eAn11+dfp9Nrvw+O8vKwG/LIc=
X-Gm-Gg: ASbGncvZuFd58pi3Txg9nACqiipeNBsffVH/kSzHttizABqcI6Ah1DXazgm3C9lMW70
	lhZfLHtrAj2pHFyOxtY4zgOL53y06ZWgCtIC+bka1toP9V1aJ9Y2oTuQDIbiSKTENhWMsupAk6p
	+bdY5XJBKkeszkx3RfVUFQlW3yCqKk12BmFQjQVU8xaVaky/Fs/rKJw4DPvupqmXdMmY/7Qy5zJ
	z8jR8wTXbozCKn/hDq9n2xCDwg0dhtrvYycIL7aYHQFbFqyC5Li/v66BKB7tC1PVE4glXc0NK/q
	Knn4uqidRt35OIO1xzTJI330SooUFpffrD9MrJ4tfJK/tW28F8ax189lTSO+faRea96Nj44D3fp
	zCy+b3ptYFLmkY8V2ByC6MhbxV1oiDntdytwKIlsn3LS4GDRGynW+dLRSwfWLBnbAtGsjoi1i2v
	/4vCGpiavVuFkTwWTgwlANgCTpaQMRd6Y=
X-Google-Smtp-Source: AGHT+IGKRy0UP3vTkTlJTpx5s9AazpWHtvbvNx1lS1PdbgNpyNUKLM1G0yemMh+rckd5h8dVv5lWbg==
X-Received: by 2002:a05:6102:5347:b0:59c:93df:4fe with SMTP id ada2fe7eead31-5d41cff3341mr5630492137.9.1759807865789;
        Mon, 06 Oct 2025 20:31:05 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-552ea335f07sm2446030e0c.15.2025.10.06.20.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 20:31:05 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCH v5 0/7] liveupdate: Rework KHO for in-kernel users
Date: Tue,  7 Oct 2025 03:30:53 +0000
Message-ID: <20251007033100.836886-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB6C61A000E
X-Stat-Signature: hf1qhi873tftdx5pq6t3351ou1uduhed
X-HE-Tag: 1759807866-648882
X-HE-Meta: U2FsdGVkX19WsJF1mOBi87HCEUog9SVRJwu2CFjmNB0Pz6r3QxPqVJmNPoVWaMj+eyFY+4K+8WoS9BKExbFZ1X6EVqQHoTtiZ10pCdxzNdJULbxkwojeE01s0HdSRHN5LNdn4LewBVdowOrfmH8lhvueNjSDS6EDfiKvZDjZm7SQ09he16KFv40IeIU0p5jhBz0/rLAn/9FKVogccwby9UzvBSPTodJu+s34u0MxRJPQw7NO+cauanL8J5B1bZRWqf354DvD8Vuys1LrpN73rmRnyCjlNTwP7nORgnJLpmgMByIlUAXtLEKki3Xstj/8awDo16SF+BHdwWHd1Xp7xh6RVHLPQ/QxOUDmLEok1hho89iZF7KFzpP/ChsiAbgIJVy92tqI4O69xYNC+SxXpOEj+bAAwYje2kKykF1qwu1xaE2YcFAlBOfmJXc5lmZ5eF7G/eVrABPBu0JgvSPHf3hxyWbAcqPAIrm1DpZxSK06whSf9xIpipNmv+3fYczYb2J2OHp5C95aurGBXdWSGU/pbBdiwTG5/9urtR4CzgmxquipWoCHliZZtdIDwELpwpAEaMmlqKnGtyh4Sfx/Ruru6vBQ/Ye4ajtO5edAkn7a4gLRUztviY40OOMbmdwnkRtzTQV5vqNQc7Z6z7a89kO8S7V6wKR2/waiEnL6pzlwqWUC0z4AYiDLo8L52KAHPhXZCkf+AXgaG4stlRyfQwFwm5qqydWL0TIjj8C6H4OhGUzr6BdOdfSw35naHYPrtNoPnnK0IFPP3cwLr+bf2M4bQNNh8dizoKWvzs+IrBCHLRjc5fzKdWwVsJM7h4BRDyOQ3aD48ZIxLiEzUHoi+41sbwKDmC4+VmWJLINOKAwWiTUVvXCzQLKg7Pi/oHKP1CSEl/hry/twlsJy5DJV0GBCj34WxDiAVRy0oN4QT+OrjXeJkxRwOpZqpd0Gvl6OFCPTwnzlANcjgRstmiJ
 mLsbjXDT
 3m5CPk2fwlHNXGB9n2JF9aGgZUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These patches are taken from the LUOv4 series [1] and address recent
comments from Pratyush.

This series refactors the KHO framework to better support in-kernel
users like the upcoming LUO. The current design, which relies on a
notifier chain and debugfs for control, is too restrictive for direct
programmatic use.

The core of this rework is the removal of the notifier chain in favor of
a direct registration API. This decouples clients from the shutdown-time
finalization sequence, allowing them to manage their preserved state
more flexibly and at any time.

In support of this new model, this series also:
 - Exports kho_finalize() and kho_abort() for programmatic control.
 - Makes the debugfs interface optional.
 - Introduces APIs to unpreserve memory and fixes a bug in the abort
   path where client state was being incorrectly discarded. Note that
   this is an interim step, as a more comprehensive fix is planned as
   part of the stateless KHO work [2].
 - Moves all KHO code into a new kernel/liveupdate/ directory to
   consolidate live update components.

[1] https://lore.kernel.org/all/20250929010321.3462457-1-pasha.tatashin@soleen.com
[2] https://lore.kernel.org/all/20251001011941.1513050-1-jasonmiu@google.com

Mike Rapoport (Microsoft) (1):
  kho: drop notifiers

Pasha Tatashin (6):
  kho: allow to drive kho from within kernel
  kho: make debugfs interface optional
  kho: add interfaces to unpreserve folios and page ranes
  kho: don't unpreserve memory during abort
  liveupdate: kho: move to kernel/liveupdate
  kho: move kho debugfs directory to liveupdate

 Documentation/core-api/kho/concepts.rst     |   2 +-
 MAINTAINERS                                 |   3 +-
 include/linux/kexec_handover.h              |  53 +-
 init/Kconfig                                |   2 +
 kernel/Kconfig.kexec                        |  15 -
 kernel/Makefile                             |   2 +-
 kernel/liveupdate/Kconfig                   |  30 ++
 kernel/liveupdate/Makefile                  |   4 +
 kernel/{ => liveupdate}/kexec_handover.c    | 515 ++++++++------------
 kernel/liveupdate/kexec_handover_debug.c    | 216 ++++++++
 kernel/liveupdate/kexec_handover_internal.h |  47 ++
 lib/test_kho.c                              |  30 +-
 mm/memblock.c                               |  60 +--
 tools/testing/selftests/kho/init.c          |   2 +-
 tools/testing/selftests/kho/vmtest.sh       |   1 +
 15 files changed, 553 insertions(+), 429 deletions(-)
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (79%)
 create mode 100644 kernel/liveupdate/kexec_handover_debug.c
 create mode 100644 kernel/liveupdate/kexec_handover_internal.h


base-commit: 4a71531471926e3c391665ee9c42f4e0295a4585
-- 
2.51.0.618.g983fd99d29-goog


