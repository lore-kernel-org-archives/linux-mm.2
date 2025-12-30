Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5502EE4983
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388BC6B0088; Tue, 30 Dec 2025 11:14:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332B46B0089; Tue, 30 Dec 2025 11:14:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263AC6B008A; Tue, 30 Dec 2025 11:14:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 170836B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:14:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABA721A024E
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:14:09 +0000 (UTC)
X-FDA: 84276634218.17.AB2FD88
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id E409B100009
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:14:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=htlMo5ze;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767111247; a=rsa-sha256;
	cv=none;
	b=b3Jo2FZq2i2E6VF3KOjr6Q1eD1qvPIZg+Df98FAv3AHTCnYAIy2J9Bv3AbuGdJKJG3qVmQ
	HHYFE8VHZ3r5uRsj3nV3L4PhdXU2sA3f9DYS7oaYmnjd4chgWMWbiwwDVvlp+YeeSeKBPs
	x4Q5bpSSVXjV/bzdnFRfl6r6JaSa47U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=htlMo5ze;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767111247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qBSp9AXI3X6i7hNQ7Mlk32H2Pu+uKCzB5Jzlrojwp1Y=;
	b=XOqhMz/t8abIWzEFXQAM9u67awcZThAT9vEAAww1RqOCAkliQGd6cQV1DmGj0uDbqRiIqS
	0uFSwnriYgcwE9luhNwFAMrpX2/BhN2LpOaf1SOSZ/nOzFyMYRbPssNkmLxeIYA1pGFxgo
	w/Ji9nOrSx/yuJZ7vOoml+p8waGhtFs=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-640d4f2f13dso8610197d50.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767111247; x=1767716047; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qBSp9AXI3X6i7hNQ7Mlk32H2Pu+uKCzB5Jzlrojwp1Y=;
        b=htlMo5zevfO72J1qPiPSbM2fmOFl0M2okaVSx9xjWXEl7PHJEHE4IKMSmF/+u53La1
         9INxsXHyiqQAAhGhQVtj1woxSaZAyV5oMzZ0n5yKrorCv4Om3l1bPrWkGesqKGcDmARP
         h40Q8Qr5UupRbYtwBj8zio9zyHreKnXQcS692pbvXpbRAISwZF0vQv+7OBuVAYedv+aJ
         m8KnhgcTkOnEptwQKZ6/e/FnPxhR0JEeNCxQ5U5VO5QB59R13456+jRFJMY2PcuQEw0H
         +Kj9bVeAfEZmCGKTiIckfDdGQvEDKzkoFWLQ8y7jWerxBZ/yRsN2ilH5Wyvpu2WL9bDK
         VYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767111247; x=1767716047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qBSp9AXI3X6i7hNQ7Mlk32H2Pu+uKCzB5Jzlrojwp1Y=;
        b=aWRwXvtoB4I+/dRmvbBcDL0RxHQXLhBfQcWz3h67rwlcmcv7Rc2mwf/hnVBbEBrAVN
         2FGQDGOqO/NMepz//bd4z4MjzJx1G0RBMwMOcDSeYIYu3er/oSh0S+LcqD4bEoc9PUyb
         oJJxU7KqCrzLkQLflnRsNtaEN9QGpWUsjZRHvEqbpTgYlazBEV6miFVJ2kJsJpb0YpX7
         NK03WKDnY/xzeBPIgY7g9PjT6BkkAIlzDAK9gCiBc1WdtV7ktbn486Z1FdQSXnBSo2mm
         CyAUki3H/hTEFw+IwwiYbg23WMkZCFUdIRWjSm2dt6svyJ/NdYkgXProlCWH8u2qWFp3
         kpww==
X-Forwarded-Encrypted: i=1; AJvYcCUey7Qoub+G0oZ4qrFUNXyb5NR0S2dhBOlO+gReRo3eYMyRw5+yhRq+DWGVvOP7r3GbX1IjiJOHow==@kvack.org
X-Gm-Message-State: AOJu0YyIKK+lc3mzA/PQd4splDWM3RqrZWryahBL0qtI0MTDzV/U4VWO
	2zp2TlF3mRvmzbLtwgLsxECJPM+WlUGAnfuahztGCoRFYU5Wt+2mWvM1V4dlCQUpKXE=
X-Gm-Gg: AY/fxX6cosYnmn5OzQeYNwHw8wJSuhwCsyWO/tVbA1x3uaBRNixAREXN/HJCYdrhx0H
	mjs8Bc5ZeZQ+LmQxN3H9qpiBQoZgvTm0/q+KAjY4ZU3Hlh2WWYuZWCjR+0yhzgaKUi56DRJclTh
	29o5jTlZNqYWqKOgc8v8m9UnBT35aytaTTurOAupogEvVNJF1HVE9jGTnuFkt3ssCk21WbYa0NM
	CBczbjAUGI89PPD2ob+dRtDKUm+CP/bfB6euLi2YypSOKje+VJyUWMtipOvW6UU5bMRn0K8UVyM
	+az9ELcQGXgS3TknzEjwxSxUkceF07nPQi1It7gyznUukhJb3vhhMoPlARuEY0+MKPUcckVZAFp
	4XF9YjkvvN1TJY2QKPXtbHjBoVSk24IVSwCgHbch1Cuf+bXHRRyVTSrCLrGCjJuCgb+YFwm9t3q
	Ubyl3WvmfH3S/rBqBoVPMEAwiOFl1W1clsWBIlFB36Bsrr+9RGs8R5yeWxnrym2lK17psIDCGvC
	eL4e+oRSTm3fHSLMIHJYkymEueQPMuqBWdXOHnnnDxzxUuH
X-Google-Smtp-Source: AGHT+IFCkJ/94XhZ+S3+kkzp+I2JnWXbfqB3JEIBTRCYeZzta8NQCJ6sPLCqEJdsH7tumGFTzabCWQ==
X-Received: by 2002:a05:690e:86:b0:645:53eb:a100 with SMTP id 956f58d0204a3-6466a845f30mr21103903d50.26.1767111246712;
        Tue, 30 Dec 2025 08:14:06 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb44f0e3csm127690847b3.28.2025.12.30.08.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 08:14:06 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pratyush@kernel.org
Subject: [PATCH v3] liveupdate: separate memfd support into LIVEUPDATE_MEMFD
Date: Tue, 30 Dec 2025 11:14:02 -0500
Message-ID: <20251230161402.1542099-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E409B100009
X-Rspamd-Server: rspam10
X-Stat-Signature: qjcbbot16fxpd88kt93a7pyneadqw9i7
X-HE-Tag: 1767111247-34460
X-HE-Meta: U2FsdGVkX18t/IHf1P/uV/TRLbaziZxnGReOA1+s6KTL2peguEExvUgmqz7dlwa3C6KfzQ1z5zRvvVla/GS6Gj/t2v6dHxWFdYdi3/6I3x9HJ2FsoWlfBFcvz6bNkrym1UIZ6wRop7jawB4k2dvslMxefHATj4V1C5fqdxOty1cezt2FyPTJ6vsJbqf7elWhh9klDDH6tlYh+29oF8vocwx35Vflfsc1t1ZkerIe31OnsTbEBg/uWPcNyqWhvT/0wm5oAh235jR8S1fpjcrubK53PaEmv1sUDS+K0Tex9+Gkx586j2Y5wn+eUoYKrUTL5WaDzTqNFL6oVtvpni3udQIOWkF0OZxMN7lYnYL4w8sgrBrwpPoI+9ILBQRZjEagiQvqJc+LI7PtufVJot7a42fUh1T4kXsXnla8k0PYMHnyf3rD6ZcP0Jj3TjVgkkxuWkomSkQAYGTXPhtzsAu2ceeLM5JXrb1zrG3EsBXW7KBfAJb4/OgXp2Vo/ACsUqbuKXVID9B/Kqt4wiu1l/wWtxy/wej+mv/4r5UaDf7F/KbESuR12lv9NbmQPuYW6GCL8hAvj14uWPpyym+DLFJUQMrwrpewI/CABqGW99/4TsWhgB+PwoDznljiRB/y/rroC7kb6+BMuxj/CZDkpdD3fKBIuX1M6ogexgpAXd+VXhnhmpWsZjs4X0FN7jsxuIFd7iHp+Af3xPyWRFzEhKjKwVXgehRLwyJkCL58G1WoLhjXMgcWu70cGSaO8tl5PYG5CGGSMiRaajwtZdBY59IAZxQf3oux7YYfBFf6Hi0i5kkhJ6yer8OnOU+H6UENNnlvBzyyCYnsqesEpwNCZNjNFJHpFxiSHNodNm4AOfi/UkSar57uBvBmYoqpWmRH7BrP7E6dIfFbF+wQsXfVxeff7+uqHn6jtdNydtwZZZqnFhzu9TvtYwDLeBcdKonoLN0kYLzBZVSp1ssSmFFXaSq
 Pq0Se1Ud
 LLfxX5nNYDltSSEPiC0xl2qZCrDMPtM4ASdoOdNJkZ32bDaqh+kpGM1VP03hm5aiENv3MpSwweOaCgAl2NMDiY5KL4RrgU7F3rLFK7vUsh26igGQA1FlyoJ9bRj0MucszmrOzv5j6DSRVlTiR/p5SO6Jjm30vZefXg5b+qClO91ToAoVa5QA2RcZ8gVL1H17J3XnRGhg2nmirC0CMynaMMAAJrV1IczUmFgOvvB2NEXqTSt23U5cLqVk9QbR+1jLWwNO+r4PAyQLt8rfHkTLk7Cx3bmqlKyFW1/TgUnQ1N6LRFidOPmbsn4EpBeQuvqJMmOESBA/mB125jGLN3sRueVka46AvEg6EaQGJlf9IhL/41O1NYOoNPqPUkVHjZupH+ileHg7QG79U9M0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Decouple memfd preservation support from the core Live Update
Orchestrator configuration.

Previously, enabling CONFIG_LIVEUPDATE forced a dependency on
CONFIG_SHMEM and unconditionally compiled memfd_luo.o. However, Live
Update may be used for purposes that do not require memfd-backed memory
preservation.

Introduce CONFIG_LIVEUPDATE_MEMFD to gate memfd_luo.o. This moves the
SHMEM and MEMFD_CREATE dependencies to the specific feature that needs
them, allowing the base LIVEUPDATE option to be selected independently
of shared memory support.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
Changes v3
- Addressed Mike's suggestion: added default LIVEUPDATE, and removed
  config from selftests.

 kernel/liveupdate/Kconfig | 17 ++++++++++++++++-
 mm/Makefile               |  2 +-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index d2aeaf13c3ac..1a8513f16ef7 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -54,7 +54,6 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 config LIVEUPDATE
 	bool "Live Update Orchestrator"
 	depends on KEXEC_HANDOVER
-	depends on SHMEM
 	help
 	  Enable the Live Update Orchestrator. Live Update is a mechanism,
 	  typically based on kexec, that allows the kernel to be updated
@@ -73,4 +72,20 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
+config LIVEUPDATE_MEMFD
+	bool "Live update support for memfd"
+	depends on LIVEUPDATE
+	depends on MEMFD_CREATE
+	depends on SHMEM
+	default LIVEUPDATE
+	help
+	  Enable live update support for memfd regions. This allows preserving
+	  memfd-backed memory across kernel live updates.
+
+	  This can be used to back VM memory with memfds, allowing the guest
+	  memory to persist, or for other user workloads needing to preserve
+	  pages.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 9175f8cc6565..798f04233d71 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -100,7 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
+obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP
-- 
2.52.0.351.gbe84eed79e-goog


