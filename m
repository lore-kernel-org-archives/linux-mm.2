Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C51CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E314D6B0026; Fri, 12 Sep 2025 11:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08D36B0028; Fri, 12 Sep 2025 11:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F096B0029; Fri, 12 Sep 2025 11:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C12996B0026
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 686001A08A5
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:01 +0000 (UTC)
X-FDA: 83880933402.01.82AD6C1
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 82F0240010
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:09:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=XQqmR2Pi;
	spf=pass (imf27.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RH4GhObM3FT55o7hGQgrlMBMoWx9IX3m3EBVgQrzYfg=;
	b=1z5iPeug33DyADDl4jEDYtEpqb313V+0N0PhBu/gTUXgda+OQOr/ZV6h7x4MVXf5pQXplZ
	ywrYduUH8yj1uqhOf0T7sBBCqorn9Z/E+eF9g6tKPGnr2fm3eswq87W7hgYyL74hEHJTfg
	LQAK9KbuktiRaBDyiUxG+weWOhxQQM4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689799; a=rsa-sha256;
	cv=none;
	b=EFopq935sX0lvhMO7VQdOnlKaAd73QvzPKW+kuSKiKobVdhD1975kl6R8VHBowS1aIyga8
	j2JnIrGiDWubdDqompXVQgUfDwr0aRR8goRDfyEf0d2JwK/LetuxUojpHNn5nuW/UpXHAX
	ZFHTGR+wYGoCwnQHd95D14EK7qY3xLM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=XQqmR2Pi;
	spf=pass (imf27.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d601859f5so14562117b3.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689798; x=1758294598; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RH4GhObM3FT55o7hGQgrlMBMoWx9IX3m3EBVgQrzYfg=;
        b=XQqmR2PijRxmBV9kgFlSOXQwiMoPtXP5LnJyFcX7YyTf2S/y/rm5N2AirK/Z2NfEkT
         IY5V0Z7ivB/LD/mXqyeJ0ZwsjO5ZyKpMrLcAQhhFNXr255fKfVNUMRnnCValu5j9uq44
         6JdtxPv7vLs15MuTzM1ztTSAAKuymnGGzP/cpbUrtPqkwJYNI7p+O6nImMTCdP+m0C6N
         7rRwRCR86DDBQ0mPZzRTFlyF87pCD24qXX1H+Stk2BEb4Ip8Ywr2LP73Dl8u7/y+U81P
         np2l4nLsc7SrCaLapezP+S/olOGKVOLdVcenpj8moZdzjahZc3ATN3vjastWdET8/kmh
         5uTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689798; x=1758294598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RH4GhObM3FT55o7hGQgrlMBMoWx9IX3m3EBVgQrzYfg=;
        b=Zm34XPAKRl+p79WXHPIydYK+H7zSVuLGSZ0dbpqEHjyDXxHYza+q9eLG9++6C7PMDP
         ywxNe+jcdCFu2y6DuODqW1bLtwe9np+AurrzVj+8osXbHUT7Z3P7DIcaQsZV1A9d6JSV
         Mm+EaKIK0bPPM1R7yaaZn1yu91rc/6+BDOciIr8lphYkVxDt6Nif/Td7QuH5W47eXDmQ
         FC65OVdEQKClwrr285iWxKPdx6kkWcs1Imto2o2GZlbcZQSM5IDW5Gin7WelqLwhi888
         Uhn7WtZpuIA9Awl/HoX+iL7n8TUoCxCutgJOV1QUxHhF+mOn9LOXfpm8SsYSRgdIB6pZ
         clMw==
X-Forwarded-Encrypted: i=1; AJvYcCW/3bu73Inro9jyuayfqxz43crRQJPtHLJQq1f7DeBR9O9+ArIzaHBMWJb1WSEemV9I++VXBonQog==@kvack.org
X-Gm-Message-State: AOJu0YxeKYvk4by73fNXq6GUcTJBlhLa61s8EDoN/ZxULNvSAGuYnO15
	OOdIFTUvTXipzDmJOgPJY5NfQV0e/s7CHipOGmKVSBsZYSXsUhdooZVzrevxjeBFhz8=
X-Gm-Gg: ASbGncsH50cD8Kdi795i8UqicXPfdW1H5gMvG2XbFY2oKAhLOUclETO4Qga0/ZSIwcK
	8Y+381IJMu+ziiiBxngd+9EFHyTrW8RhxPotLBiQtszTNPUS14unLXJ2Mogydwx3EQ6VVrbyJb+
	McbeyJKgxLdNbeX7gQ6J0QhAecYOv6mOGbCr6s3HZ59VHXlJ/8dUMVpAxKrI9DUJhl80ihxKVHM
	5tL3LcaMPJ03mIq3TdvLsN2/+9NqLEbWcNiy0yvnlm8D9XDB+NpqT0cmgURGh4dMGB2+ZrnHZFo
	GP+D/UagwmAdGSfJJciWmzw77qfCT1zm9Sb/F0QYS9wPa8E4Hv/akFjXHFVutGMWD5ZHibDI8zN
	AL1dYLx8JrYaFTKb6sMk9b7c70UOuMnMjMERlfvGDAZdU
X-Google-Smtp-Source: AGHT+IHDbtGqslyeLn4YFWeoqnBwKggrxCYxTs3G1b8DQvW49OjHmQw5TtCHo1C0fUHoFsODFmt/wQ==
X-Received: by 2002:a05:690c:660b:b0:721:7e7:50d with SMTP id 00721157ae682-730651d60dcmr29556217b3.42.1757689798342;
        Fri, 12 Sep 2025 08:09:58 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:09:58 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 02/16] Documentation: Add kmemdump
Date: Fri, 12 Sep 2025 18:08:41 +0300
Message-ID: <20250912150855.2901211-3-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 98xozdf3uwu51scimwtkzwxpqrptdqbg
X-Rspamd-Queue-Id: 82F0240010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757689799-639231
X-HE-Meta: U2FsdGVkX1/LiGZoi/6hM/AlMb44nLUC5cVHfU+QE6rAiTJEiJZNDXiI7TbTyfXDw5vuimLK28AetUFM0ODQ8o/AIjtFTENdkpU7lijvDZHvDKOFXrSsu9URvTQwyM2idsMWdrr+eQi2PtId/iKlVEG5dgG02bm2gxoGlba5GclXQUF6fQrChq+1H6/P9bN2Nr1tBse7IwPuuLnHUTR5wpvhTkKTJ29jauG/eYL6M7HB5A61Yk1xY7e2D50ZTfgfX3X+2ZOpkfP5Qi6NR3CIPMpKcAkaBGAWc0bHPdNTWmMOCyWfjgCKr5R6e5nODMIKz171EENswBwGM8XTu7uzNYtXmMI4/Z/LivnXYE7CyuVDTtYpZIxsCtj5nJhMYJsf/09YwWFgHC0crz6U7kk9K5KXIbUVXv3zhw7XZ04Nh+Sc5rPak97XA+KBM0iAxMklJ0FamRZp8RzcZNuWbmKngAVEtsmNWdCBAth6qCIY5wQjLcUPRDThbxtRMVZhRHAoAOIyK4L0FnN536xq6fKClvQKKp/hAqu+K1X3XV3aM57gFnURfYEr4DmK2a6c6Xrfrx82z4ps94u3zMhcsjG5DrccteyhrojEG0RZCDIVb+EKDAUxHtN7xHO8pLMQnSg10L+EVU5jT4r6lEnmRq8Th37M9osdC38qXey/ci/In3Fui2g7Tzo7+uEC/sM1dL9t3tUU5yqpK0fKNGYo3IRIgmWdRIpgp3Js8nou+ovMmo3teJkqzqLdVLy4G8aEFH1Uoszre28XTxQpxNLO1mchB9tfZD0ohnOuaFiIerqc4Z0S/w8pMN3dp/1KPUKHuUI7mkYdog9uUba+6/5waIVNGRqOCkk9Orovxq0Q8oTXYWaVZeGcD2BAB9iHdBoHlnpsKcc9OK9dfOp4kTZc0IiT/2ezRiUwu5si7fgTCmNWuKRTEL/uMuKHUteR31dUWhDveqxuHnhYLlXpcZQ2Hnv
 OaIcR3GZ
 fuv1NZ7ceo5nqWwzpW/cW56OBCL+QZPQfKbEr/oxjVDLDaTaml8OJ9JrUmm2Eq+ZMgZJV6hF00eSDHQf+yxc6VYj9hJkYoEYBN/q+x+UZjOI7zV3py+tNcAhOOES+E0BbNi/s3pN5BNR/ksq+vlB0LgvJJ8AEEwr4svVHIpGdItnBh9DHqpbINWosIlq3qHyTNFcudA22ECKNIPICdsa4Cse75fdnjlU3bTC/9XEkhUbgGO9/9FyXU46RqlpY4FLqBVsyMhzlQpT7qlxR+32EDcFQtT8XN+N+KR1O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the new kmemdump kernel feature.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 Documentation/dev-tools/index.rst    |   1 +
 Documentation/dev-tools/kmemdump.rst | 131 +++++++++++++++++++++++++++
 MAINTAINERS                          |   1 +
 3 files changed, 133 insertions(+)
 create mode 100644 Documentation/dev-tools/kmemdump.rst

diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 65c54b27a60b..1b6674efeda0 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -28,6 +28,7 @@ Documentation/process/debugging/index.rst
    kmsan
    ubsan
    kmemleak
+   kmemdump
    kcsan
    kfence
    kselftest
diff --git a/Documentation/dev-tools/kmemdump.rst b/Documentation/dev-tools/kmemdump.rst
new file mode 100644
index 000000000000..504321de951a
--- /dev/null
+++ b/Documentation/dev-tools/kmemdump.rst
@@ -0,0 +1,131 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========
+kmemdump
+========
+
+This document provides information about the kmemdump feature.
+
+Overview
+========
+
+kmemdump is a mechanism that allows any driver or producer to register a
+chunk of memory into it, to be used at a later time for a specific
+purpose like debugging or memory dumping.
+
+kmemdump allows a backend to be connected, this backend interfaces a
+specific hardware that can debug or dump the memory previously registered
+into kmemdump.
+
+The reasoning for kmemdump is to minimize the required debug information
+in case of a kernel problem. A traditional debug method involves dumping
+the whole kernel memory and then inspecting it. Kmemdump allows the
+users to select which memory is of interest, in order to help this
+specific use case in production, where memory and connectivity
+are limited.
+
+Although the kernel has multiple debugging mechanisms, kmemdump fits
+a particular model which is not covered by the others.
+
+kmemdump Internals
+==================
+
+API
+---
+
+A memory region is being registered with a call to kmemdump_register() which
+takes as parameters the ID of the region, a pointer to the virtual memory
+start address and the size. If successful, this call returns an unique ID for
+the allocated zone (either the requested ID or an allocated ID).
+IDs are predefined in the kmemdump header. A second registration with the
+same ID is not allowed, the caller needs to deregister first.
+A dedicated NO_ID is defined, which has kmemdump allocate a new unique ID
+for the request and return it. This case is useful with multiple dynamic
+loop allocations where ID is not significant.
+
+The region would be registered with a call to kmemdump_unregister() which
+takes the id as a parameter.
+
+For dynamically allocated memory, kmemdump defines a variety of wrappers
+on top of allocation functions which are given as parameters.
+This makes the dynamic allocation easy to use without additional calls
+to registration functions. However kmemdump still exposes the register API
+for cases where it may be needed (e.g. size is not exactly known at allocation
+time).
+
+For static variables, a variety of annotation macros are provided. These
+macros will create an annotation struct inside a separate section.
+
+
+Backend
+-------
+
+Backend is represented by a struct kmemdump_backend which has to be filled
+in by the backend driver. Further, this struct is being passed to kmemdump
+with a backend_register() call. backend_unregister() will remove the backend
+from kmemdump.
+
+Once a backend is being registered, all previously registered regions are
+being sent to the backend for registration.
+
+When the backend is being removed, all regions are being first deregistered
+from the backend.
+
+kmemdump will request the backend to register a region with register_region()
+call, and deregister a region with unregister_region() call. These two
+functions are mandatory to be provided by a backend at registration time.
+
+Data structures
+---------------
+
+struct kmemdump_backend represents the kmemdump backend and should be
+initialized by the backend driver.
+
+The regions are being stored in a simple fixed size array. It avoids
+memory allocation overhead. This is not performance critical nor does
+allocating a few hundred entries create a memory consumption problem.
+
+The static variables registered into kmemdump are being annotated into
+a dedicated .kemdump memory section. This is then walked by kmemdump
+at a later time and each variable is registered.
+
+kmemdump Initialization
+-----------------------
+
+After system boots, kmemdump will be ready to accept region registration
+from producer drivers. Even if the backend may not be registered yet,
+there is a default no-op backend that is registered. At any time the backend
+can be changed with a real backend in which case all regions are being
+registered to the new backend.
+
+backend functionality
+---------------------
+
+kmemdump backend can keep it's own list of regions and use the specific
+hardware available to dump the memory regions or use them for debugging.
+
+kmemdump example
+================
+
+A production scenario for kmemdump is the following:
+The kernel registers the linux_banner variable into kmemdump with
+a simple call like:
+
+  kmemdump_register(linux_banner, sizeof(linux_banner));
+
+The backend will receive a call to it's register_region() callback after it
+probes and registers with kmemdump.
+The backend will then note into a specific table the address of the banner
+and the size of it.
+The specific table is then written to a shared memory area that can be
+read by upper level firmware.
+When the kernel freezes (hypothetically), the kernel will no longer feed
+the watchdog. The watchdog will trigger a higher exception level interrupt
+which will be handled by the upper level firmware. This firmware will then
+read the shared memory table and find an entry with the start and size of
+the banner. It will then copy it for debugging purpose. The upper level
+firmware will then be able to provide useful debugging information,
+like in this example, the banner.
+
+As seen here, kmemdump facilitates the interaction between the kernel
+and a specific backend.
diff --git a/MAINTAINERS b/MAINTAINERS
index 1713cccefc91..974f43c3902b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13813,6 +13813,7 @@ F:	drivers/iio/accel/kionix-kx022a*
 KMEMDUMP
 M:	Eugen Hristev <eugen.hristev@linaro.org>
 S:	Maintained
+F:	Documentation/dev-tools/kmemdump.rst
 F:	include/linux/kmemdump.h
 F:	mm/kmemdump/kmemdump.c
 
-- 
2.43.0


