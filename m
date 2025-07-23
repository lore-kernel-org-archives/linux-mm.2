Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72F1C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011F06B0116; Wed, 23 Jul 2025 10:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04D26B0117; Wed, 23 Jul 2025 10:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7FE36B0118; Wed, 23 Jul 2025 10:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2E706B0116
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87F661A0736
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:30 +0000 (UTC)
X-FDA: 83695807860.05.FD94557
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C580C0009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=HDOVVXq8;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9OeQwvAtSpE7KYIsGHzDzwJJRVZThZJEHAd4sog2is=;
	b=LPzAL2NT1gIUM2eGC3HbFxyKohcxS++vE+bHIVJY9PgpF1qURp/fWjnFVIqJhEuPw/Qrsc
	om6EuooJ6Gdd9JBjsDqSSaxzYL4WmfbBwpZ91Q9q8AbIhOAg5rHZ6dU0C8BwpXmFvavwjp
	4HSepj859gtd0/KScPJBjz0nSmVAbes=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282048; a=rsa-sha256;
	cv=none;
	b=FdFEyWKLWMN94ngnRS7+p9766l3mPHnCHI3ksiYt+J2nobdVhF69HYIQHV2jvLdZUnFpa7
	2heFY1BFbCicBfkzoyPT9mvkG9u6/SGl8P7PpS7FOGbJ90HVhXYHJoEmIBiK0G8Ur+PRph
	KzU6ts3WFb9s8oGk8o8kuxqyhKZH0vw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=HDOVVXq8;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7183d264e55so67246127b3.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282048; x=1753886848; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q9OeQwvAtSpE7KYIsGHzDzwJJRVZThZJEHAd4sog2is=;
        b=HDOVVXq8EaoLRZEjk4H4Ex9kEu8PLVYhFMNJF3ymLuLSEu5wfROPYmJgP23tm92hUy
         hU+UU25K1/MK0Yzk+7Sr+lQALofjVY1OLGQqFbBrckIkUWGoWtEfdz+xcmGDbdffDLlm
         EZs9WkEsvq4Phw/njFXg2f5i6OQrrCoEVggliagnmnFFyJ+qFaEWEsAXfaOegp5tzrL7
         qk9l3PToJvHOSZ+FRHuweMBb3DYQEO2WWhQsrhtbty61KXZTvZihwVP0FEuteEcV1WKw
         6azz/9aaWkPxQyES5JzpL7nGnhL468AByQpw+WN/PGnuqu6wGyaZ8fZzsFHeD9tC8P+a
         APJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282048; x=1753886848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q9OeQwvAtSpE7KYIsGHzDzwJJRVZThZJEHAd4sog2is=;
        b=EEpR2rxhqCCPwqyuxlZfbSFrCH0sTsKZcEzl8T7m6pp/zmZP7x5+kir04RQYC38czU
         Md6yjGzQ8xAFcmuCr+9Q4rtprhuxOFANiSVCnAbALGZzKZB9JngSqG7s/vQWj7Ok6eW2
         10NCOKUXZ99T6ZDB1MnNDrM7zhivxqWPaRNEqmxcGGbIJyfrwM2NP3/tw578ZZ5wXMGO
         Z7BfNdMUQKKCrYg0gWKGJL+zhbbhy95iasF910b5c3xIUtIfTz8mC1yjDzv+5dIS3fZj
         c7+wfgxv9YdTKa9kh41hgKOkFHFByvWCFdqoelnDF3C01bucPz28juTGTM7ap/2brIgT
         R6EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVV63UilI4us12j89bE4ipbXeg69RFFJrpyhm2mbjk72/O2kcVgX15JLabXuhK2mWGzASS10nVpaw==@kvack.org
X-Gm-Message-State: AOJu0Yx9+n8zjxurWSkel8jyx+Xo2Ugqam8FcTPHvS8tXt1X8xSG7b2q
	QQxRs/FSNaulPfBQbIQQVj2trkARozYx6QWXEeqdRUoP481gWEQ1kpCU4KhT8bpkKco=
X-Gm-Gg: ASbGncspHhdTm5EN2q0xA+raCNI6z0mg3K6MBFrYdaiaoLFLnUm+KwOGqWXTJbiehDW
	24Ph2yyw0C5Po02wP37OmhPlzlAMnPr6FcrsFN+OOzFLz+xeenh+9InUV7igf03y72Ar5Ca2eDQ
	xzKUvgdM00RZlrAN0TQrvdtLeW6nmY6nAEMlMHSjN0tybflUVQg9jf7Z5pjIub12M3HegCIrZpa
	klvJ2a9xulApkz8PDr8/3XwXOIePYtTEwmwEQi6YbXE0HVTkBONDu80AQvcdrf5IJaiJ9xwHeNF
	/md5ZOPfFX7lBJRRNXDzAa4K4yvZpd0bnEx/NbETSfD7/ouQ7qONjYaxiODVO9t6sF2PIIlUC0Z
	uLGaCuz+NsMQftB7Zz719b1Y952U3Xgs9izHZKI5g1uswYH6HepDA9Ee7eKHGjuIgkL0wdrcZKa
	j+hWFkzpen5t1iIYHq2ezUft5l
X-Google-Smtp-Source: AGHT+IF4tR956kUR9cpPnn2sFwi5VeVXYICzL+BOy6UFPlMUfshdtWwybksAvrcMrknJvRf/sOFakA==
X-Received: by 2002:a05:690c:4d83:b0:70e:7503:1181 with SMTP id 00721157ae682-719b41660f4mr39787257b3.18.1753282047128;
        Wed, 23 Jul 2025 07:47:27 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:26 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v2 16/32] liveupdate: luo_ioctl: add ioctl interface
Date: Wed, 23 Jul 2025 14:46:29 +0000
Message-ID: <20250723144649.1696299-17-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9C580C0009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: nc5ruzan374pfu1tx1rmsa4ygkm7bou4
X-HE-Tag: 1753282048-185478
X-HE-Meta: U2FsdGVkX1+5Wze8PaEbXSp2ERKsBchNwH7YrHnMqZK1nlI5cRo5t0F91AHIenLIqRPliQWqXmjhvdSi6z4kRyicvu2HoQdPvUEvpXsS2qfhSC7HnJIGKzAHL4YWk1D4dBPxR3uv6B5Es8q+EPwMpqbaCtejCNr02THVl18t2sNkPag7pzBHYhys0vKCsxekWiyE7/TS8KHLS+eW7qONW6ZC2NkOOoEvJnn/GVygPeGqyrf5KvbfPBVg2V30hWE7+R1s7K+3sVFNvJy9+nykqjQsoN5QByqVeHFWFjHHuyj9m470eIqb1hP1Xaid9lkKctmiNt6+XXwGSdzV4LH9axL71747cV3Rt/uUJVWC7o6hc6Yqt3W9qLQCGuwPsSyoIgRHN987B3PInyzmcu2ow+TuD0lKWdX6ZLEseWh03vPCDxDq7IDrS+9i+JZGvOJK7W6wkamgzSY3g9ZmLWIHJYj76Snh4NcPLT5OzV1AOGXsyI1o6p8vOx/6cX7Pz+4YZ5cMQlqrnXdN5do1EPP2oazv5MKPJLlB/vSmvuw1RMntSkJi+1n00ZG3e8pNwHbWTGVe03pq9DaL/Vui4envV6hKSwwjPES8iovkP6CBOsppFN3IQ+XpXGiVLOKQD3bMDtWrazCJfhNtBRO3J0z84XcPqDcYL3Ql3t8dzCKA0ebueKKPB95lM0rUtkuuf6OhmFcBNr97Z1J4d8TMH0UGUJrQLskZVFHtYFNUMOZQgn4mad9nAd6Hmd62oiZ1x1zMG+Gwdmlgn7A7Jbs1gkYd4vUJ4gosyPf671jFJH1kRQR8u1RaWQ2VEftn2pgk4PB8eZmJ/fyPVA4T2Sw8f8OSLgV5tRnfAlRHeuoHiejsbqukVBTh+HVyPaacfd1iUgvrPVrFwUhPcl6bgromTEL4GxHY1YXzfk5fC5jjNQX0+RXYey5DFGvgTTnLQ/NU3j2kMunwW88emRrh0YuHU3A
 EqzvnZz5
 aqHkAS9JsNXiHkRnbAFfSKl+hJWYAwl5QFUT0a0eOSkXxmIQ01K3Yti6nyYkC8tri6bBQ410LIwwWsQ9/RzzCVnaERijGzwADoatiF74I+NuPhYLZMrHL9xty+ZJE2SB1Z3ASYfwPPnDKM/4l9JEhBbM+lVG0mDBp2y+Ywe+uBVOtvtB76EVazBdmS6zg0NuUaMaXGbnKaUCCjX14k088g+ybNznAGia23nXZBWbhcCNwRQT3duLqfZBeDVSmIomUjSsozth3g9EEw+uTUKQORzPZEiLPGQ7dTOWiinlCX14ty1uj+ALaTv7wmPjsfHKOhCKgq0fdV2DEHfdCQVsaVKYItGiybtykRsoSoUYPIuDdWdJID2PjymgdOJrAYn+ylb/MhGqdvqDnZQBrg+3KFBW+yjqeqoNwq9/KlAIcgEieDbrf7Fw9Rhos0USDHkbYakL0nVixwTm4SJel/WQfb6vQDC2jK3jJRroyWBNc5p0PvrArGlBtcIFJO18WdKTgSq7WmDS0U9zcp3Vrg9SjdANlOPltsTq0Rvhzfv7IA5wHW2hwPXOeA0hN+HpZmRTGMfg4jan4Fep6B+sQJzInExBWZq8Ect7ZRP32
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the user-space interface for the Live Update Orchestrator
via ioctl commands, enabling external control over the live update
process and management of preserved resources.

Create a character device at /dev/liveupdate. Access
to this device requires the CAP_SYS_ADMIN capability.

A new uAPI header, <uapi/linux/liveupdate.h>, defines the necessary
structures. The magic number is registered in
Documentation/userspace-api/ioctl/ioctl-number.rst.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 include/linux/liveupdate.h                    |  36 +--
 include/uapi/linux/liveupdate.h               | 265 ++++++++++++++++++
 kernel/liveupdate/Makefile                    |   1 +
 kernel/liveupdate/luo_ioctl.c                 | 178 ++++++++++++
 5 files changed, 447 insertions(+), 35 deletions(-)
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/luo_ioctl.c

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index bc91756bde73..8368aa05b4df 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -380,6 +380,8 @@ Code  Seq#    Include File                                           Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                              Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                       Microsoft Hyper-V /dev/mshv driver
                                                                      <mailto:linux-hyperv@vger.kernel.org>
+0xBA  all    uapi/linux/liveupdate.h                                 Pasha Tatashin
+                                                                     <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
 0xCA  00-0F  uapi/misc/cxl.h                                         Dead since 6.15
 0xCA  10-2F  uapi/misc/ocxl.h
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 28a8aa4cafca..970447de5d8c 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -10,6 +10,7 @@
 #include <linux/bug.h>
 #include <linux/types.h>
 #include <linux/list.h>
+#include <uapi/linux/liveupdate.h>
 
 /**
  * enum liveupdate_event - Events that trigger live update callbacks.
@@ -53,41 +54,6 @@ enum liveupdate_event {
 	LIVEUPDATE_CANCEL,
 };
 
-/**
- * enum liveupdate_state - Defines the possible states of the live update
- * orchestrator.
- * @LIVEUPDATE_STATE_UNDEFINED:      State has not yet been initialized.
- * @LIVEUPDATE_STATE_NORMAL:         Default state, no live update in progress.
- * @LIVEUPDATE_STATE_PREPARED:       Live update is prepared for reboot; the
- *                                   LIVEUPDATE_PREPARE callbacks have completed
- *                                   successfully.
- *                                   Devices might operate in a limited state
- *                                   for example the participating devices might
- *                                   not be allowed to unbind, and also the
- *                                   setting up of new DMA mappings might be
- *                                   disabled in this state.
- * @LIVEUPDATE_STATE_FROZEN:         The final reboot event
- *                                   (%LIVEUPDATE_FREEZE) has been sent, and the
- *                                   system is performing its final state saving
- *                                   within the "blackout window". User
- *                                   workloads must be suspended. The actual
- *                                   reboot (kexec) into the next kernel is
- *                                   imminent.
- * @LIVEUPDATE_STATE_UPDATED:        The system has rebooted into the next
- *                                   kernel via live update the system is now
- *                                   running the next kernel, awaiting the
- *                                   finish event.
- *
- * These states track the progress and outcome of a live update operation.
- */
-enum liveupdate_state  {
-	LIVEUPDATE_STATE_UNDEFINED = 0,
-	LIVEUPDATE_STATE_NORMAL = 1,
-	LIVEUPDATE_STATE_PREPARED = 2,
-	LIVEUPDATE_STATE_FROZEN = 3,
-	LIVEUPDATE_STATE_UPDATED = 4,
-};
-
 struct file;
 
 /**
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
new file mode 100644
index 000000000000..7b12a1073c3c
--- /dev/null
+++ b/include/uapi/linux/liveupdate.h
@@ -0,0 +1,265 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+/*
+ * Userspace interface for /dev/liveupdate
+ * Live Update Orchestrator
+ *
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef _UAPI_LIVEUPDATE_H
+#define _UAPI_LIVEUPDATE_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/**
+ * enum liveupdate_state - Defines the possible states of the live update
+ * orchestrator.
+ * @LIVEUPDATE_STATE_UNDEFINED:      State has not yet been initialized.
+ * @LIVEUPDATE_STATE_NORMAL:         Default state, no live update in progress.
+ * @LIVEUPDATE_STATE_PREPARED:       Live update is prepared for reboot; the
+ *                                   LIVEUPDATE_PREPARE callbacks have completed
+ *                                   successfully.
+ *                                   Devices might operate in a limited state
+ *                                   for example the participating devices might
+ *                                   not be allowed to unbind, and also the
+ *                                   setting up of new DMA mappings might be
+ *                                   disabled in this state.
+ * @LIVEUPDATE_STATE_FROZEN:         The final reboot event
+ *                                   (%LIVEUPDATE_FREEZE) has been sent, and the
+ *                                   system is performing its final state saving
+ *                                   within the "blackout window". User
+ *                                   workloads must be suspended. The actual
+ *                                   reboot (kexec) into the next kernel is
+ *                                   imminent.
+ * @LIVEUPDATE_STATE_UPDATED:        The system has rebooted into the next
+ *                                   kernel via live update the system is now
+ *                                   running the next kernel, awaiting the
+ *                                   finish event.
+ *
+ * These states track the progress and outcome of a live update operation.
+ */
+enum liveupdate_state  {
+	LIVEUPDATE_STATE_UNDEFINED = 0,
+	LIVEUPDATE_STATE_NORMAL = 1,
+	LIVEUPDATE_STATE_PREPARED = 2,
+	LIVEUPDATE_STATE_FROZEN = 3,
+	LIVEUPDATE_STATE_UPDATED = 4,
+};
+
+/**
+ * struct liveupdate_fd - Holds parameters for preserving and restoring file
+ * descriptors across live update.
+ * @fd:    Input for %LIVEUPDATE_IOCTL_FD_PRESERVE: The user-space file
+ *         descriptor to be preserved.
+ *         Output for %LIVEUPDATE_IOCTL_FD_RESTORE: The new file descriptor
+ *         representing the fully restored kernel resource.
+ * @flags: Unused, reserved for future expansion, must be set to 0.
+ * @token: Input for %LIVEUPDATE_IOCTL_FD_PRESERVE: An opaque, unique token
+ *         preserved for preserved resource.
+ *         Input for %LIVEUPDATE_IOCTL_FD_RESTORE: The token previously
+ *         provided to the preserve ioctl for the resource to be restored.
+ *
+ * This structure is used as the argument for the %LIVEUPDATE_IOCTL_FD_PRESERVE
+ * and %LIVEUPDATE_IOCTL_FD_RESTORE ioctls. These ioctls allow specific types
+ * of file descriptors (for example memfd, kvm, iommufd, and VFIO) to have their
+ * underlying kernel state preserved across a live update cycle.
+ *
+ * To preserve an FD, user space passes this struct to
+ * %LIVEUPDATE_IOCTL_FD_PRESERVE with the @fd field set. On success, the
+ * kernel uses the @token field to uniquly associate the preserved FD.
+ *
+ * After the live update transition, user space passes the struct populated with
+ * the *same* @token to %LIVEUPDATE_IOCTL_FD_RESTORE. The kernel uses the @token
+ * to find the preserved state and, on success, populates the @fd field with a
+ * new file descriptor referring to the restored resource.
+ */
+struct liveupdate_fd {
+	int		fd;
+	__u32		flags;
+	__aligned_u64	token;
+};
+
+/* The ioctl type, documented in ioctl-number.rst */
+#define LIVEUPDATE_IOCTL_TYPE		0xBA
+
+/**
+ * LIVEUPDATE_IOCTL_FD_PRESERVE - Validate and initiate preservation for a file
+ * descriptor.
+ *
+ * Argument: Pointer to &struct liveupdate_fd.
+ *
+ * User sets the @fd field identifying the file descriptor to preserve
+ * (e.g., memfd, kvm, iommufd, VFIO). The kernel validates if this FD type
+ * and its dependencies are supported for preservation. If validation passes,
+ * the kernel marks the FD internally and *initiates the process* of preparing
+ * its state for saving. The actual snapshotting of the state typically occurs
+ * during the subsequent %LIVEUPDATE_IOCTL_PREPARE execution phase, though
+ * some finalization might occur during freeze.
+ * On successful validation and initiation, the kernel uses the @token
+ * field with an opaque identifier representing the resource being preserved.
+ * This token confirms the FD is targeted for preservation and is required for
+ * the subsequent %LIVEUPDATE_IOCTL_FD_RESTORE call after the live update.
+ *
+ * Return: 0 on success (validation passed, preservation initiated), negative
+ * error code on failure (e.g., unsupported FD type, dependency issue,
+ * validation failed).
+ */
+#define LIVEUPDATE_IOCTL_FD_PRESERVE					\
+	_IOW(LIVEUPDATE_IOCTL_TYPE, 0x00, struct liveupdate_fd)
+
+/**
+ * LIVEUPDATE_IOCTL_FD_UNPRESERVE - Remove a file descriptor from the
+ * preservation list.
+ *
+ * Argument: Pointer to __u64 token.
+ *
+ * Allows user space to explicitly remove a file descriptor from the set of
+ * items marked as potentially preservable. User space provides a pointer to the
+ * __u64 @token that was previously returned by a successful
+ * %LIVEUPDATE_IOCTL_FD_PRESERVE call (potentially from a prior, possibly
+ * cancelled, live update attempt). The kernel reads the token value from the
+ * provided user-space address.
+ *
+ * On success, the kernel removes the corresponding entry (identified by the
+ * token value read from the user pointer) from its internal preservation list.
+ * The provided @token (representing the now-removed entry) becomes invalid
+ * after this call.
+ *
+ * Return: 0 on success, negative error code on failure (e.g., -EBUSY or -EINVAL
+ * if not in %LIVEUPDATE_STATE_NORMAL, bad address provided, invalid token value
+ * read, token not found).
+ */
+#define LIVEUPDATE_IOCTL_FD_UNPRESERVE					\
+	_IOW(LIVEUPDATE_IOCTL_TYPE, 0x01, __u64)
+
+/**
+ * LIVEUPDATE_IOCTL_FD_RESTORE - Restore a previously preserved file descriptor.
+ *
+ * Argument: Pointer to &struct liveupdate_fd.
+ *
+ * User sets the @token field to the value obtained from a successful
+ * %LIVEUPDATE_IOCTL_FD_PRESERVE call before the live update. On success,
+ * the kernel restores the state (saved during the PREPARE/FREEZE phases)
+ * associated with the token and populates the @fd field with a new file
+ * descriptor referencing the restored resource in the current (new) kernel.
+ * This operation must be performed *before* signaling completion via
+ * %LIVEUPDATE_IOCTL_FINISH.
+ *
+ * Return: 0 on success, negative error code on failure (e.g., invalid token).
+ */
+#define LIVEUPDATE_IOCTL_FD_RESTORE					\
+	_IOWR(LIVEUPDATE_IOCTL_TYPE, 0x02, struct liveupdate_fd)
+
+/**
+ * LIVEUPDATE_IOCTL_GET_STATE - Query the current state of the live update
+ * orchestrator.
+ *
+ * Argument: Pointer to &enum liveupdate_state.
+ *
+ * The kernel fills the enum value pointed to by the argument with the current
+ * state of the live update subsystem. Possible states are:
+ *
+ * - %LIVEUPDATE_STATE_NORMAL:   Default state; no live update operation is
+ *                               currently in progress.
+ * - %LIVEUPDATE_STATE_PREPARED: The preparation phase (triggered by
+ *                               %LIVEUPDATE_IOCTL_PREPARE) has completed
+ *                               successfully. The system is ready for the
+ *                               reboot transition. Note that some
+ *                               device operations (e.g., unbinding, new DMA
+ *                               mappings) might be restricted in this state.
+ * - %LIVEUPDATE_STATE_UPDATED:  The system has successfully rebooted into the
+ *                               new kernel via live update. It is now running
+ *                               the new kernel code and is awaiting the
+ *                               completion signal from user space via
+ *                               %LIVEUPDATE_IOCTL_FINISH after
+ *                               restoration tasks are done.
+ *
+ * See the definition of &enum liveupdate_state for more details on each state.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+#define LIVEUPDATE_IOCTL_GET_STATE					\
+	_IOR(LIVEUPDATE_IOCTL_TYPE, 0x03, enum liveupdate_state)
+
+/**
+ * LIVEUPDATE_IOCTL_PREPARE - Initiate preparation phase and trigger state
+ * saving.
+ *
+ * Argument: None.
+ *
+ * Initiates the live update preparation phase. This action corresponds to
+ * the internal %LIVEUPDATE_PREPARE. This typically triggers the saving process
+ * for items marked via the PRESERVE ioctls. This typically occurs *before*
+ * the "blackout window", while user applications (e.g., VMs) may still be
+ * running. Kernel subsystems receiving the %LIVEUPDATE_PREPARE event should
+ * serialize necessary state. This command does not transfer data.
+ *
+ * Return: 0 on success, negative error code on failure. Transitions state
+ * towards %LIVEUPDATE_STATE_PREPARED on success.
+ */
+#define LIVEUPDATE_IOCTL_PREPARE					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, 0x04)
+
+/**
+ * LIVEUPDATE_IOCTL_CANCEL - Cancel the live update preparation phase.
+ *
+ * Argument: None.
+ *
+ * Notifies the live update subsystem to abort the preparation sequence
+ * potentially initiated by %LIVEUPDATE_IOCTL_PREPARE. This action
+ * typically corresponds to the internal %LIVEUPDATE_CANCEL kernel event,
+ * which might also be triggered automatically if the PREPARE stage fails
+ * internally.
+ *
+ * When triggered, subsystems receiving the %LIVEUPDATE_CANCEL event should
+ * revert any state changes or actions taken specifically for the aborted
+ * prepare phase (e.g., discard partially serialized state). The kernel
+ * releases resources allocated specifically for this *aborted preparation
+ * attempt*.
+ *
+ * This operation cancels the current *attempt* to prepare for a live update
+ * but does **not** remove previously validated items from the internal list
+ * of potentially preservable resources. Consequently, preservation tokens
+ * previously generated by successful %LIVEUPDATE_IOCTL_FD_PRESERVE or calls
+ * generally **remain valid** as identifiers for those potentially preservable
+ * resources. However, since the system state returns towards
+ * %LIVEUPDATE_STATE_NORMAL, user space must initiate a new live update sequence
+ * (starting with %LIVEUPDATE_IOCTL_PREPARE) to proceed with an update
+ * using these (or other) tokens.
+ *
+ * This command does not transfer data. Kernel callbacks for the
+ * %LIVEUPDATE_CANCEL event must not fail.
+ *
+ * Return: 0 on success, negative error code on failure. Transitions state back
+ * towards %LIVEUPDATE_STATE_NORMAL on success.
+ */
+#define LIVEUPDATE_IOCTL_CANCEL						\
+	_IO(LIVEUPDATE_IOCTL_TYPE, 0x06)
+
+/**
+ * LIVEUPDATE_IOCTL_EVENT_FINISH - Signal restoration completion and trigger
+ * cleanup.
+ *
+ * Argument: None.
+ *
+ * Signals that user space has completed all necessary restoration actions in
+ * the new kernel (after a live update reboot). This action corresponds to the
+ * internal %LIVEUPDATE_FINISH kernel event. Calling this ioctl triggers the
+ * cleanup phase: any resources that were successfully preserved but were *not*
+ * subsequently restored (reclaimed) via the RESTORE ioctls will have their
+ * preserved state discarded and associated kernel resources released. Involved
+ * devices may be reset. All desired restorations *must* be completed *before*
+ * this. Kernel callbacks for the %LIVEUPDATE_FINISH event must not fail.
+ * Successfully completing this phase transitions the system state from
+ * %LIVEUPDATE_STATE_UPDATED back to %LIVEUPDATE_STATE_NORMAL. This command does
+ * not transfer data.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+#define LIVEUPDATE_IOCTL_FINISH						\
+	_IO(LIVEUPDATE_IOCTL_TYPE, 0x07)
+
+#endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index b5054140b9a9..cb3ea380f6b9 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_core.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_files.o
+obj-$(CONFIG_LIVEUPDATE)		+= luo_ioctl.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_subsystems.o
diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
new file mode 100644
index 000000000000..3de1d243df5a
--- /dev/null
+++ b/kernel/liveupdate/luo_ioctl.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: LUO ioctl Interface
+ *
+ * The IOCTL user-space control interface for the LUO subsystem.
+ * It registers a misc character device, typically found at ``/dev/liveupdate``,
+ * which allows privileged userspace applications (requiring %CAP_SYS_ADMIN) to
+ * manage and monitor the LUO state machine and associated resources like
+ * preservable file descriptors.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/liveupdate.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <uapi/linux/liveupdate.h>
+#include "luo_internal.h"
+
+static int luo_ioctl_fd_restore(struct liveupdate_fd *luo_fd)
+{
+	struct file *file;
+	int ret;
+	int fd;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		pr_err("Failed to allocate new fd: %d\n", fd);
+		return fd;
+	}
+
+	ret = luo_retrieve_file(luo_fd->token, &file);
+	if (ret < 0) {
+		put_unused_fd(fd);
+
+		return ret;
+	}
+
+	fd_install(fd, file);
+	luo_fd->fd = fd;
+
+	return 0;
+}
+
+static int luo_open(struct inode *inodep, struct file *filep)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (filep->f_flags & O_EXCL)
+		return -EINVAL;
+
+	return 0;
+}
+
+static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct liveupdate_fd luo_fd;
+	enum liveupdate_state state;
+	int ret = 0;
+	u64 token;
+
+	if (_IOC_TYPE(cmd) != LIVEUPDATE_IOCTL_TYPE)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case LIVEUPDATE_IOCTL_GET_STATE:
+		state = liveupdate_get_state();
+		if (copy_to_user(argp, &state, sizeof(state)))
+			ret = -EFAULT;
+		break;
+
+	case LIVEUPDATE_IOCTL_PREPARE:
+		ret = luo_prepare();
+		break;
+
+	case LIVEUPDATE_IOCTL_FINISH:
+		ret = luo_finish();
+		break;
+
+	case LIVEUPDATE_IOCTL_CANCEL:
+		ret = luo_cancel();
+		break;
+
+	case LIVEUPDATE_IOCTL_FD_PRESERVE:
+		if (copy_from_user(&luo_fd, argp, sizeof(luo_fd))) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = luo_register_file(luo_fd.token, luo_fd.fd);
+		if (!ret && copy_to_user(argp, &luo_fd, sizeof(luo_fd))) {
+			WARN_ON_ONCE(luo_unregister_file(luo_fd.token));
+			ret = -EFAULT;
+		}
+		break;
+
+	case LIVEUPDATE_IOCTL_FD_UNPRESERVE:
+		if (copy_from_user(&token, argp, sizeof(u64))) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = luo_unregister_file(token);
+		break;
+
+	case LIVEUPDATE_IOCTL_FD_RESTORE:
+		if (copy_from_user(&luo_fd, argp, sizeof(luo_fd))) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = luo_ioctl_fd_restore(&luo_fd);
+		if (!ret && copy_to_user(argp, &luo_fd, sizeof(luo_fd)))
+			ret = -EFAULT;
+		break;
+
+	default:
+		pr_warn("ioctl: unknown command nr: 0x%x\n", _IOC_NR(cmd));
+		ret = -ENOTTY;
+		break;
+	}
+
+	return ret;
+}
+
+static const struct file_operations fops = {
+	.owner          = THIS_MODULE,
+	.open           = luo_open,
+	.unlocked_ioctl = luo_ioctl,
+};
+
+static struct miscdevice liveupdate_miscdev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name  = "liveupdate",
+	.fops  = &fops,
+};
+
+static int __init liveupdate_init(void)
+{
+	int err;
+
+	if (!liveupdate_enabled())
+		return 0;
+
+	err = misc_register(&liveupdate_miscdev);
+	if (err < 0) {
+		pr_err("Failed to register misc device '%s': %d\n",
+		       liveupdate_miscdev.name, err);
+	}
+
+	return err;
+}
+module_init(liveupdate_init);
+
+static void __exit liveupdate_exit(void)
+{
+	misc_deregister(&liveupdate_miscdev);
+}
+module_exit(liveupdate_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pasha Tatashin");
+MODULE_DESCRIPTION("Live Update Orchestrator");
+MODULE_VERSION("0.1");
-- 
2.50.0.727.gbf7dc18ff4-goog


