Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C94CE8D4A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5F98E000C; Fri, 14 Nov 2025 10:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575C58E0002; Fri, 14 Nov 2025 10:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43DEA8E000C; Fri, 14 Nov 2025 10:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBF48E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D745EB9573
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:05 +0000 (UTC)
X-FDA: 84109658850.20.1A87446
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0D7E51A0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=B2nZ4q6x;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GfZyo9u25oM70F0ygQaaTqn4+hpd1ir7NjzpQRKKylc=;
	b=B1e8RsNqXgPorHaEWPJkHosUN+8qQ+VOr/VQmAClMjGUnhbiQboZL5CRFJMhbbvVlGejN4
	bbwg1ixSS/YqO/KIc28h4B2JOQDY8yKRIdDxfv2bxnObU8Kqc5VWA+bXf9p9PQPjPVtTj2
	KfYnzVRJlum0apuPFHCaQEYY5D7Y6t4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=B2nZ4q6x;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135644; a=rsa-sha256;
	cv=none;
	b=d2rk/AQl8TgtvxXSntuhG8pZ3NZVH/0FamJLXNfI6ODSgUYgRH7PXn4xP3KP3piXZWU7py
	n49FvDB63Z7DQNM8RkOrlRDMZjQVrR85zONcmUXHLYFLMQrr4BibVfuKUV/+p55RD4PYm7
	+WJ+8nzMz8Th7jzN1NtLoqsi0hiiZo0=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-63fc8c337f2so1923502d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135643; x=1763740443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=GfZyo9u25oM70F0ygQaaTqn4+hpd1ir7NjzpQRKKylc=;
        b=B2nZ4q6xtcwIPbUbNGeM1K/GGYmirqy9/Lyg9tVOU5g4wWYhZvAslRb2/sdFRsIKbS
         Mac04h+T+hm7wNVAX0X2CMOlEScTjJDcMEv6F9CzuhQJCu59aOa//zdE993IEAiGMlTk
         F/pykx9Y1fVwOnxu7ZTAIQdxzmJ0gWSCElugZNmgHjzRj73eMqMX3HIqB5d5Ojwoh2MW
         iDDBNsM52A0RmiPMyFEPK4JtRGQ3VLqdHuYQq1zqzR4pn2sMiqAoFGvjAH9AFKkdSxmc
         8icOpHL5gplPZ0+UXklQYCVuaD0PdMubgtkufFKKyeWLVt3ntUZ67O4lvV3z0r6lBHtt
         AVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135643; x=1763740443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GfZyo9u25oM70F0ygQaaTqn4+hpd1ir7NjzpQRKKylc=;
        b=T5jX/yVZBDAN67VRWAsKMs5w8FvrlmcdjCO2CVv/0hdjmOIKF9KdAjd58sG+dam1/2
         qNgEGco+Ls/i+w7+6R5nPRoLFlLxREzsTY3SOI+eAKRBCWtxrKaRKEFPPrVfbOUiaoLC
         gmfLP7FezaSydtgoDnS54qx+r2fCgNYbFy16hIXAbPMJLpCd8+L85Btbl7Vkm4LNJcMu
         TQkazM4x/Upg5vCRtOpwmHGcacfJTtXUCZUrAbxnBSku8mjhhPa3GHHFYU3DRBSLIShb
         u8vuk5p1IbMZhhfwJckiIsDcyWHy6lfGfRm/jkESuXAYAuIgpBVOnuSrxg6A8RGGXqiK
         sKPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAZI5C9M76JgY9xkFmS9mKbN0K2ParkzGsZB9bBvEor9+7bstCoCS4p4bpb1CqeD44xmvrWUewlw==@kvack.org
X-Gm-Message-State: AOJu0Yxxv+KKareob86q+vx0qqlh3EqXsHIe9agsr5VDshYs1AyKbA2X
	ofxjdioJB+EYGl4gIrt9nSSXLdKe3uFW5VdE49jiTuf77b3cyAYfwInm9QFazNtiBA4=
X-Gm-Gg: ASbGncupGZ/UI+KTUEl+yG4o8BWw2jlhtr7JQ3uPw5nF6HoRMCyBD7WBKX4rOqWBbLk
	tbo3TB4o7hylbfCWMrsHqPd3bTELRosbhdUdU91C4kMtERW8oDZbP08saApwa1Hik1OY3aAdVGU
	OSKriEYL32BBrr264vqPuKXnN8BoHNWjMggepEcEkn+FMpkgKdtw0r9ZQAzybvqP/fysZf12chr
	J5KamURotioL2P3BAC7cuT0g/K1V1xxM89vuk9TRChN/iIWfB8tVmHJ9zkmTI4Q19pZIn0nJQ90
	jPYqHK6PmEhFIFcysgXfNkoBaGvf/jfELoEqbqgEjkBKpJWQWap7OhyGSbNVbIDV4TOhu0yz0Ru
	jG+J+SJ5ag374EjalU32YJysE6aghZYNsc2RK0Vp+71TkmJZsVhwwtZE27Liy8LrYVfZF94Z4Zp
	2ep6Q28ubdXx6EhxrUVxR1XdzNlN+/fgI9Kb9jXBIhD/+M6DNlQVIFSCNdNhixdC/kaTiYgtHx0
	29t7FI=
X-Google-Smtp-Source: AGHT+IEkRZsenlzrshhmVUXkMssN1FuHmBAG4UEJw+j/0VvWJXbh4MXHIwmGsrrNxwXibEcnyWDXfw==
X-Received: by 2002:a05:690c:9684:b0:787:cddb:ec2d with SMTP id 00721157ae682-78929e2b535mr63260347b3.19.1763135642698;
        Fri, 14 Nov 2025 07:54:02 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:02 -0800 (PST)
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
Subject: [PATCH v1 00/13] kho: simplify state machine and enable dynamic updates
Date: Fri, 14 Nov 2025 10:53:45 -0500
Message-ID: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0D7E51A0002
X-Stat-Signature: zwa1a8zeh69yxajns69zbxiohx5167cm
X-Rspam-User: 
X-HE-Tag: 1763135643-30749
X-HE-Meta: U2FsdGVkX1934FuMkE37fzkexuBN/gVhOnkoOafyqH8q5LVpc+NZb5gQ/gb//8qRPzVg1u6jAQFypIus4h+Pt13CJZdSyDJQXy994QWzR2mGaKuxDxYydSwZ2oJCpjzcBppcogi0KBgNPD9njLYdDHi7sIqpD9e0MIz/uL50rpLozu5sQtFvsc0zUluV80x+aelDBoRO7Ne1L2puaFhTAMhiva8yFP6O2CfM+6ZX0zfrYkBE61jgFayUtyn8+NHtSfEjRZQBF1rjiNXDOv8Ba59lkFy5SgppUlHkUoSj8dDXb4VyIbrdOmIyGI7Pn0blGsWOsHHTfoJBzVasFRhQBqTQjNVurdoRJk+CnXBl8NMqDjjiRNQ7yavI8cWZ3vBzIirzaJKrNw3Fcr0x5Ftmqy7apHEMrq5sqrmoO6bXIbPJV8mYHTKZ3HLhZ8xYHIt7PZLceb5W9twWWQFrXeGTHEbMrg/fGNzRlqxEdRsBaw1qqJNUdNEbZ6a+NUG7fv9JmdzViTW8I1qkfwsuj4bfXKbjDMM5ie4dHRiRswt7BB3GwGa8WwRmbhF8PBE+1dXPqogh0qUVw4NvO5Q1RNFCx/Xk+AgNziagdEDDjOgaNNsNP2RixXONPhEwfbPUiEDWBgYM4UjSFiRK6TO0j7qPwi4MgEi/NqTzZikPEam2Elt9nv/Cf1HaYzyksXZidLKP/Rp28DnligwasL3S4gOooA3JFQVfZj6osl8DrW87GlJE8jDVkjXdXHpy3mGmr07EBfsEUf9EZJZZIEKb4dI7kn39rK8/Zvj2C9rMcq7s3WC5h/Vs+xaMH0ZGFbt8FuwYvVhccqrrNXpv3TSNri631TmXgC+7jlkgiW6Btn4goFURcOkl8NjR9muWuhtHCal1bsWBplSiTN6XPR+DXqzeeBW9TonS3+lxK6e6uzObeacu/VgUa+Tnu/8ETZOP7aay1n1OsYMC/XAIokm+abb
 8IRXb7QS
 QmGLMASeV/stYr+WV4D2R03uYBULF9mUpel+78YJMAcTxv5RchMQduLSCVUVt0wCK/ER8EZZTuQkD8hQsgt4GzxdY109rWBMiLYQKP15ToltVk3Wy5L4ps6CnMJ8tr8vnXFW9YdbEKZ7Cqw8uQQV4ypU6PqFx5nOZJXkxZuNmxEZOahYwWMFb9aszO1+49g9HpoVE8or1t11ErV2oDVlHcFJFQXpKJ2oCAq5GIAKTtAhR816MvTotnFBfNKxEmk7ve67T/b71uT/vp9w=
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
  kho: Introduce high-level memory allocation API

 include/linux/kexec_handover.h              |  22 +-
 kernel/liveupdate/Kconfig                   |  14 +
 kernel/liveupdate/kexec_handover.c          | 338 ++++++++++++--------
 kernel/liveupdate/kexec_handover_debugfs.c  |   2 +-
 kernel/liveupdate/kexec_handover_internal.h |   1 -
 5 files changed, 232 insertions(+), 145 deletions(-)

-- 
2.52.0.rc1.455.g30608eb744-goog


