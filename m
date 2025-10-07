Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAF2CCD183
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 03:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607B58E0002; Mon,  6 Oct 2025 23:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5901B8E000C; Mon,  6 Oct 2025 23:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4563D8E0002; Mon,  6 Oct 2025 23:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 293DC8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:31:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C873AB9ED1
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:17 +0000 (UTC)
X-FDA: 83969892594.26.9E35E64
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0639A14000D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hWlPzzCS;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759807876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VBEGNGPrHJLgeZc8OwSpyVwglko2eCUcGTlg3MZ+0E=;
	b=r61KeNaQWbjjQjwEK4mrmyZgN1SpZaZ4Z5r4df/NAnjXGZx1XegEyY6Vv+gUbiKByzDZy9
	L5emJwfmKtm7SVkOw4tPiLehzsAIe8kYoNWR96soSSxwYaqdeu9kNFYu5ELWo1EQg8BzwI
	+4wTJMo48Sy7GopJREitDlfTmfgYYaw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759807876; a=rsa-sha256;
	cv=none;
	b=Gwo8pdOoGMzgwtEirAvOuPyQ0jy11qtEKr/rPThM3eZumRV4VFvwgkzzb6q1pPjgkDCwrS
	QGEq710i9rn4yz33R5ZTnqZg68UDzfYI/6JGgVqZ49fOFkpG9WmeC0eaSYe5jYNLJTPx2I
	GFNDhzgnsLdUqnwuRRZnRS1Kmi9XqVY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hWlPzzCS;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-930989f9f81so219474241.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 20:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759807875; x=1760412675; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3VBEGNGPrHJLgeZc8OwSpyVwglko2eCUcGTlg3MZ+0E=;
        b=hWlPzzCSU7YYy+sHfB/9PxVATj8bZNRwcFQGBCeNjiJUENqd7cbWoHSWE8Dvtdv+e5
         Z1cAtVyJHkzKAPlSK1D11V2ZCc3IX6C3czIr1kBaMja/b6i6yTwaGAvQl3KLann5B9lQ
         GStAMcr/B8tv1DRYvBHUTD7QFKY+BTZrPQzDlaMDbHUiA5O8cjqJFUOGIvp/Bjcx94Fs
         Rd19Hb/6JgZGKiS9gxLBGux3W+WYBOXJ7ii7Kxmh9h7BR5iIGZDR75CJXCq3+lfskHSc
         KdkRK32zbOTjI3H+i3+Fkyv+mzF2svhRKf8SJ162P3FKmXOl1Zn42xK7J040mEumO5+9
         Nprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759807875; x=1760412675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3VBEGNGPrHJLgeZc8OwSpyVwglko2eCUcGTlg3MZ+0E=;
        b=vhNz+K8MlO/MiBJvw3J4nU57S58cRb286tg7mwXCboJDBFR3mhg64gsUhpdN6vL6hu
         Dfw3BbeE32MlRD2sC89EBJvByyawhLC0svbQqo3xllFaJpr6v4TLhqCgyc06F1G7tnZe
         vzk2EoxqHq50a5U8uYMrzxh6JRY4Ro5F9vd/c8qYuwt00NIU7+ocULPau7YQwSIMwG/H
         xRgC44kiKMO8s8gsLAlnxLO2xyrmjY5sV5DJI5ddBcPYwO96Uab6dOyGvD63TF84T2RT
         ikY+wDq7dPDBETF3xaYjeGA47ok49xePxpBdEMmMOpZlVU0WXLhbNRtFMgEQwScpbi7E
         9wAg==
X-Forwarded-Encrypted: i=1; AJvYcCXvaNIxEqmPLMIeM8/ri5qrspzCeuYhLxKPVmZxkMTmpUiCySmKhjd9uXbbnKFemnZ/L6QphqnPeQ==@kvack.org
X-Gm-Message-State: AOJu0YxyEUbHtek12Vo2ES3YdVgKDnBcKhvd8FIUHLqJwCO8pMTYxzwv
	bmQzYTv35tsJGaIv+Ehsspde2rkGVc9Ped6F70IJDMMMqGQYxKuJCtjcppnifn/5Do8=
X-Gm-Gg: ASbGncsLJSVXlI4TypLV48e5boZ/v2BIM/hWQHOkGenobFqYqqcSCSNGVmK+5JJN4nB
	dTBd8PpNx6BTN6cr6mgbQMsrMhhfnDKLI8Gzy8/DtKNIkbTqU3v0WzWlym81yTkDA+RP/NkQJ+P
	/cCVYKPZdFE2DvfgKNqYuAKKxbsu1vKbrrVRBc++pELGY0K7vxaZ0snrwflePznQnyUKFXlaKGr
	AY6JVRoLW3ub0DGpefuRkhlspviFNdM/bxu3mJ7T28yXEw3frM5R4S3Pd1nQIt7pZ8GiCvT7+Uw
	r6llYuUXH7rBgd0GGaAb0RJH/aNUrTCR4JiHJrCa1M/ZaqqsfsFvRx6Yv+ZMOTvltt8dKcH2GHV
	/mWTaJrQjjvv8loiMzTMuI2dyDHBk8EbGdrMiYi04xIUlu8cL198Q6Ohb8tX9Gt4FCmRtHxfxSz
	zaey98ZpoxLIt43Hzov2EfGZYiOZddo7BchcFbb3y4Uw==
X-Google-Smtp-Source: AGHT+IEm4J6yFD10/rZ/XdNA9W6YeHZUIRIn81vHOvDBC4QHa+8Eq0vvy55tHiaoLOJh8X8oN4bNLg==
X-Received: by 2002:a05:6122:1781:b0:54a:9e47:7624 with SMTP id 71dfb90a1353d-5524ea910damr5388462e0c.14.1759807875038;
        Mon, 06 Oct 2025 20:31:15 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-552ea335f07sm2446030e0c.15.2025.10.06.20.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 20:31:14 -0700 (PDT)
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
Subject: [PATCH v5 7/7] kho: move kho debugfs directory to liveupdate
Date: Tue,  7 Oct 2025 03:31:00 +0000
Message-ID: <20251007033100.836886-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
In-Reply-To: <20251007033100.836886-1-pasha.tatashin@soleen.com>
References: <20251007033100.836886-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: rfk89eziwah66wctjuybioj1xin1pgn6
X-Rspam-User: 
X-Rspamd-Queue-Id: 0639A14000D
X-HE-Tag: 1759807875-843361
X-HE-Meta: U2FsdGVkX1/zTEQvb2pZQKiBGcU3GOkPZSWdKAKaM83ZnSmREvCDAwZGZOtAAaEecKHQtU22NcfSCvrouXR25gHMnkwTCa+t/D6JVR5LcufUYNudG+bFr4HFjQfQiHYKA5G5P6c2gbDyFveDJliXu9a/wde78o1/CRhrRMYKudTDzqVSf3vPl2iUaVT8WzBC/X6IX3Lv60+aTtqC6SV/TqEECq6u/utLo8d/c3Vu30PKqUijCqCy1u3aZe4IrUpKzEQX1gdRisma+vA5j1fY2rPIQ/P6K+2hWkrg2mcpzEq9nVbwZtbaNOV5pZbo5oeNagGDT8Jcjmx0UDub9erEw98F8h4yNrsthTj2THrPo5Guih0mZD9gsOcWaRsSMxMOp2UoOZTc+PW4quwrkfukqJDSLBwhSFhCb70RRamI6DHX4ipm4yJUkvX/moFUQtt6K3/yryREV5W44H0y+OpJEBryTvjiISUZ//cit9nsS5Zcs0GbedatAHjwnEDeKSXInzcAy01x+qj5YNyvu3NK1UVYqL/Vx2dD5/zoBvCW1pbyJ7dBnjhQYr5UhkugtZ/AD8EuSgS1g0WKdExQMYTMFs8AbVYkYOcZN/5DzIs6XFGhLM8Rma+IXCm3M/FGBZpKok4tuOHbRfmbz010KbY+uH4PPrGYlZXM7XB+ajqyCwW1XZ19KEjdDtmhWn05KLwb5XEYnjjiWCUd4tpcc21Hf7Ze2Bubhil2HICc1LXtkvPR9C3ll/AnhARdfaeqW592mpqK5yAyS2gIMpXgvHcq4pe2sIT/KBfR4SNM6q23/BZWHtbpSz1jJOMOBDCTzJ427luOVJump1Li9OelEl6nicqfjt7rZ/HteHajvGVHluSGQ7KKe2H5D2Qp/Tcf4uX1Bxb0rLXcoWZEfNgHz4J6T72zmww/TZ/tNrg5Zl227adUXsTWebdeenXbkFHPtGkfOkn8yQCQiY118vLc1Cv
 dB+ANOmm
 ENtgDmlq3YZZbdHmDrgbgFMDfTK0jj4mtVZPk/XDTPweF9tMG+FmwpSaGZffQLtNYSL0h6PW0VheoVEpqRUgTS1TtIGrW8B6zQrfmwrH4G9JddzZzGgpL3o5PBQFBK9UwcVkoWRxxODY8ldB9F09z/tcolpHN55eemKwSB3hPsa+b+wn/LsCzsrP1aCerEbSZbUkBQGIlNbkkkqxWqb4lHqHNjFvQpNeLLM1ISuxBSoi6BZsykf0Wd6HURifZuo4hEoHJvuA2tkgYoT68mF4o6AVPuJqfiYFPMKowOGqYWTw2IRijLwUuXaIYeaegXHN0QP8TYxuCKrKteMM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, that LUO and KHO both live under kernel/liveupdate, it makes
sense to also move the kho debugfs files to liveupdate/

The old names:
/sys/kernel/debug/kho/out/
/sys/kernel/debug/kho/in/

The new names:
/sys/kernel/debug/liveupdate/kho_out/
/sys/kernel/debug/liveupdate/kho_in/

Also, export the liveupdate_debufs_root, so future LUO selftests could
use it as well.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover_debug.c    | 10 +++++-----
 kernel/liveupdate/kexec_handover_internal.h |  2 ++
 tools/testing/selftests/kho/init.c          |  2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
index d4ac78d53a39..eb47f000887d 100644
--- a/kernel/liveupdate/kexec_handover_debug.c
+++ b/kernel/liveupdate/kexec_handover_debug.c
@@ -15,7 +15,7 @@
 #include <linux/mm.h>
 #include "kexec_handover_internal.h"
 
-static struct dentry *debugfs_root;
+struct dentry *liveupdate_debugfs_root;
 
 struct fdt_debugfs {
 	struct list_head list;
@@ -115,7 +115,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("in", debugfs_root);
+	dir = debugfs_create_dir("kho_in", liveupdate_debugfs_root);
 	if (IS_ERR(dir)) {
 		err = PTR_ERR(dir);
 		goto err_out;
@@ -175,7 +175,7 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("out", debugfs_root);
+	dir = debugfs_create_dir("kho_out", liveupdate_debugfs_root);
 	if (IS_ERR(dir))
 		return -ENOMEM;
 
@@ -209,8 +209,8 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 __init int kho_debugfs_init(void)
 {
-	debugfs_root = debugfs_create_dir("kho", NULL);
-	if (IS_ERR(debugfs_root))
+	liveupdate_debugfs_root = debugfs_create_dir("liveupdate", NULL);
+	if (IS_ERR(liveupdate_debugfs_root))
 		return -ENOENT;
 	return 0;
 }
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index de90a678274d..b3fc1957affa 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -15,6 +15,8 @@ struct kho_debugfs {
 	struct list_head fdt_list;
 };
 
+extern struct dentry *liveupdate_debugfs_root;
+
 #else
 struct kho_debugfs {};
 #endif
diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
index 6d9e91d55d68..f0136a30ce8b 100644
--- a/tools/testing/selftests/kho/init.c
+++ b/tools/testing/selftests/kho/init.c
@@ -11,7 +11,7 @@
 /* from arch/x86/include/asm/setup.h */
 #define COMMAND_LINE_SIZE	2048
 
-#define KHO_FINALIZE "/debugfs/kho/out/finalize"
+#define KHO_FINALIZE "/debugfs/liveupdate/kho_out/finalize"
 #define KERNEL_IMAGE "/kernel"
 
 static int mount_filesystems(void)
-- 
2.51.0.618.g983fd99d29-goog


