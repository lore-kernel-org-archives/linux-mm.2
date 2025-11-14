Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE82CE8D6F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19598E000B; Fri, 14 Nov 2025 14:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0C48E0006; Fri, 14 Nov 2025 14:00:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C054D8E000B; Fri, 14 Nov 2025 14:00:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B11378E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 535F012DDC2
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:10 +0000 (UTC)
X-FDA: 84110127780.07.2196E17
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 82389160006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=esuohtpb;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2ynEGaaFlXl5pRf2RlXwOY5XT3fIRPtXpC81p1D2lHc=;
	b=p67Hsgj+OPOJVl1fhM4UCy2mIYxWQQz3SzrBfdaw8GAZ9zFo62E4GPzLoPW/RmE7pSAj45
	tU3f3rvSa1DJdlcBIOdL4qDWQWEv8wDFtpcJpXgI51VSn8lBzqltIJHghn8tL8xZHD7rcW
	SvQ8NMdvDgjGKbeT/yf1sPGZAIxsxyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146808; a=rsa-sha256;
	cv=none;
	b=HaWDyRANXfyH6pHA0OjXs5QG9fqWUK5e3u1jwbTwK6CmTEg9g9oO/W1Td9PuN+ZR3Pu1db
	/0kpLQ2L4ZTZErRHgwFfRX6Fs/OBIRNmDuGEUXb0sJHGChjJr3eX4DlVxqGI6NALxnVDkn
	5YtTZG0+zsEpCb16bwzGNNM56g2QgQ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=esuohtpb;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-640d790d444so2124165d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146807; x=1763751607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=2ynEGaaFlXl5pRf2RlXwOY5XT3fIRPtXpC81p1D2lHc=;
        b=esuohtpbgv77PZr4HwrvxcXt90mM4K0AYu1EJtV9uS21Di0nSS4gFyMcSNMExsw+2v
         3l55oouTVwvq06ufZHZm1O+EB6Typ9L9FRONfGbwHlpG/0arqBxGkGghFHS0OMQrpXd1
         z7g9/VOQYkw37LS5fTOi1uPRRLD4ML0dWQCE4tWzBvVOUED5XKX6E7gokRPC7d0rSX2x
         E9AbbC3i82oBM9yrMeNmnhGPhwjee/KF7DYAfUVxQAUGXV62GuzVH5nEIKl2fvXEQiSX
         zger6Cn6sc5KXo8Rfm9GwbYnEW/avT0HV4dQMQmLMaRj8YQjYIQ9VK8wyyJrBf7mPpPU
         huXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146807; x=1763751607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ynEGaaFlXl5pRf2RlXwOY5XT3fIRPtXpC81p1D2lHc=;
        b=Nsa6gINDSyyCa9ShULgoinqd5mBqhSv8YkP3CRHEdcOSfQvuhR7e2J8SA7JsxJg7HF
         vf67M/3Ma7vSx97Na8gMCyugH272yciqTTel7IRt//fWntZdwztIJLTTYOSJ9+hVC1j9
         rvhi+4cf9+sdUOxOqHsQwFuKWmTotvr0f/EpQeAXv7CsUJICHGFBnlht+nbWJOB2NJ+F
         i7PYS66KJFbKKXEhApLmYHgrt9fbR2VuUwx4EBpp9IqE9DT1cau4QbI8x/67eqaoGXLb
         rEZivzYjQecFvPHl2O6+Nhn9qdCQbcTSFicQZKWfj6FnXeNXYS68peuJvKumWlzjQ7Pc
         pieg==
X-Forwarded-Encrypted: i=1; AJvYcCVh/dSVlNVN6fgm/ugJHZZtvYciYufv24daRfz95MOuzXhzLYuj7ypX+HYUwGuUQglgekWVEU4Q2A==@kvack.org
X-Gm-Message-State: AOJu0YwnAU3N1mh9rizjc+goMYUjNQGBVgqGJa4RJkaFh2z/oTfMihrz
	Eha02M0GjW4FOw96ztMXBoaNpZo/WUyPu5nYNzNt6qlLWk5XIMPw5gWWX/zyIeKRYC8=
X-Gm-Gg: ASbGncvlrESjq37m4gFMEhWitRm0PQ6GZ+wG6yJ3cNBtnoDrWBIKA9/43iJLjc6E6+d
	hnPJpl8jSJRl2XDcsLVnpom97QEPJc1iIUM1pF7FUQ4RtRdQqgNslhQJLPdMpRPBqNk5wVcv4yt
	AeMMEEFiEj7qsNpR9B3EmWiGNr8l07mAIx/+//8qJC/tMPXq2qLXJsfAroBw8z0dbUMewfAKJP8
	xvBSJpJY/mac/dW+tKK7suJpZOeRj/aLzIogJrBy4R5HP/slJbN9hW4XdpINRknyIw1sk5YxIxm
	jsK0aSrTN9F2hDi/BYXfFXG0aXGwyo5DlXcuDf/wtPf9Nvsuf9yOy0RmourAE1SMk0xG4VAt9m8
	bOXOMwd2NK1xJBSsWxzqvahHjbkWE4G8cQDF6dN9Cc+r+wBoyvblVcowbHa05n1jboZgbcMWN1K
	BqNmFIjJcLR5ZOzHw03+pOFPvbzwvPpJWAcRylVLwrix+uGlyWZjVq4HhBogcRLI85NEq7
X-Google-Smtp-Source: AGHT+IG6J0fpAFCsZp1+i5tq0KAD1Wez8HNyVZg+mc+XRWcBCobADV0IJzvXz9gbQ6SWF+7u8SY7KQ==
X-Received: by 2002:a05:690e:2457:b0:63f:c52c:3828 with SMTP id 956f58d0204a3-641e75bab8fmr2669367d50.26.1763146807242;
        Fri, 14 Nov 2025 11:00:07 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:06 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 00/13] kho: simplify state machine and enable dynamic updates
Date: Fri, 14 Nov 2025 13:59:49 -0500
Message-ID: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 82389160006
X-Stat-Signature: 5y7jjy53nj97wtemk6myunueww1cxtzb
X-HE-Tag: 1763146808-477332
X-HE-Meta: U2FsdGVkX18ciKMDjV5mYm7OF1xr1SILHaqE30VYkPf8t7Q76AgXjuA6Ld6X4Cz47CmECLBLTbQa0yAGiyY2p97L0wfgXtKLiIMSQzoBLxOpi8+FECnw2rtUTZJ2p5byaoOpabHtxkexbHQGOBj/tZ1wtQApkFAhlhek3UvTjvClT/OJq5hyBgn4M5e8V1jG9d/A/fEXgwajR8/ictK3auR3B0pdmUDrgXQlrxXVTSISFldlnnDm+owA7lT68A8mpyQ85Ke9J2C82JXvSIvRezs0xWi2/oN482DEiJ9ag+qQ+rjz+xBlH4xqiumBOEK3gHgYgqEcPAMjxPqi70fVWeve8N6rx+gxPvbGhxuf92P4pPwkkDnyC5h/eudv9d/ystySugaIEErarJvQDXERAdSuQr3yWd1w9SP8r5HfA8n8UHZ+60uTTfhXsbW3uxSqvqeVGluW5fd8EB6ZA85es92OgNrMu5XAN6x4k7QSNLPM85mTDd0B7DGlWY1z6PZQO1Lfe07f71bC2unSe52nKg8d7Z71G6yMeSQZyMWS8TRBDhaNxMrZrZ4N+FuMM1/WP9L5IiEXb3/P12VcE1xW8/j8jxcQKU3GyZSy23rVtyD4h+xBq45TCkmpsh6i5UoJvSZ7XW85ZqyLkjoTgAuieEdgDBQxWIksHv16In/V0RXUAw/SVpcGapsRm+diAr2F6jSYdkD6IWu0zbWgTOcy9TMr3MouAZiJH5UGVtYgryvpARx5IDm64L7v/pXOdYWtVwG26+Y4n6YNmRIcG+Xgqm9Y4wPt63LHOzLFd0xr48V3f0hKFH0eMYXYb2kK6wIoJvQr31JGbyyzuSNUXhVFG8O8d8GBWkix60cUEs6XhWLFiT6rqLAGa9FULTdtPy4sQdt2dTGg5xto1kJQCu1pNO8Qe16ArOGZseboHv6g5g4kipjYg3jFsOEakTMZZ1DLBa8lgy3TJOE1tfPeddZ
 3/ZBk1gN
 BvfppiVWviPWX6xuEANqPLk/vF0Ig+1P9mjRXLQncNALT2Z7F4irtKbRQtX3UJATmlzQF7zHGv0WbOQ/b4ET5h/ySg2UrDCSDDiuAlqX2oY1kMJm42VOC5L2aHEXz29yk0u9QH1OSs4JX7x2VklqFz6Nuy1dERL+aSboNnXDMNKb5/hx36VzKvOnsP29hGbbb/pzG/YdHjiIO2e9ZoELuohE0XJiaMoaKkKmlx1BzkJjktzyoQGAh5gkTESR/Ev7qgk4oB39OKnLxeX4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew: This series applies against mm-nonmm-unstable, but should
go right before LUOv5, i.e. on top of:
"liveupdate: kho: use %pe format specifier for error pointer printing"

Changelog v2:
- Addressed comments from Mike and Pratyush
- Added Review-bys.

It also replaces the following patches, that once applied should be
dropped from mm-nonmm-unstable:
"liveupdate: kho: when live update add KHO image during kexec load"
"liveupdate: Kconfig: make debugfs optional"
"kho: enable KHO by default"

This patch series refactors the Kexec Handover subsystem to transition
from a rigid, state-locked model to a dynamic, re-entrant architecture.
It also introduces usability improvements.

Motivation
Currently, KHO relies on a strict state machine where memory
preservation is locked upon finalization. If a change is required, the
user must explicitly "abort" to reset the state. Additionally, the kexec
image cannot be loaded until KHO is finalized, and the FDT is rebuilt
from scratch on every finalization.

This series simplifies this workflow to support "load early, finalize
late" scenarios.

Key Changes

State Machine Simplification:
- Removed kho_abort(). kho_finalize() is now re-entrant; calling it a
  second time automatically flushes the previous serialized state and
  generates a fresh one.

- Removed kho_out.finalized checks from preservation APIs, allowing
  drivers to add/remove pages even after an initial finalization.

- Decoupled kexec_file_load from KHO finalization. The KHO FDT physical
  address is now stable from boot, allowing the kexec image to be loaded
  before the handover metadata is finalized.

FDT Management:
- The FDT is now updated in-place dynamically when subtrees are added or
  removed, removing the need for complex reconstruction logic.

- The output FDT is always exposed in debugfs (initialized and zeroed at
  boot), improving visibility and debugging capabilities throughout the
  system lifecycle.

- Removed the redundant global preserved_mem_map pointer, establishing
  the FDT property as the single source of truth.

New Features & API Enhancements:
- High-Level Allocators: Introduced kho_alloc_preserve() and friends to
  reduce boilerplate for drivers that need to allocate, preserve, and
  eventually restore simple memory buffers.

- Configuration: Added CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT to allow KHO
  to be active by default without requiring the kho=on command line
  parameter.

Fixes:
- Fixed potential alignment faults when accessing 64-bit FDT properties.

- Fixed the lifecycle of the FDT folio preservation (now preserved once
  at init).

Pasha Tatashin (13):
  kho: Fix misleading log message in kho_populate()
  kho: Convert __kho_abort() to return void
  kho: Introduce high-level memory allocation API
  kho: Preserve FDT folio only once during initialization
  kho: Verify deserialization status and fix FDT alignment access
  kho: Always expose output FDT in debugfs
  kho: Simplify serialization and remove __kho_abort
  kho: Remove global preserved_mem_map and store state in FDT
  kho: Remove abort functionality and support state refresh
  kho: Update FDT dynamically for subtree addition/removal
  kho: Allow kexec load before KHO finalization
  kho: Allow memory preservation state updates after finalization
  kho: Add Kconfig option to enable KHO by default

 include/linux/kexec_handover.h              |  39 +-
 kernel/liveupdate/Kconfig                   |  14 +
 kernel/liveupdate/kexec_handover.c          | 378 +++++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c  |   2 +-
 kernel/liveupdate/kexec_handover_internal.h |   1 -
 5 files changed, 239 insertions(+), 195 deletions(-)

-- 
2.52.0.rc1.455.g30608eb744-goog


