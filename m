Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2492CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E33E8E0011; Fri,  7 Nov 2025 16:05:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393BF8E000D; Fri,  7 Nov 2025 16:05:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D8C8E0011; Fri,  7 Nov 2025 16:05:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08BEB8E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:05:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC6FA59C33
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:44 +0000 (UTC)
X-FDA: 84085042608.19.E6863FE
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC42740014
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DiFh36xm;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9ls15f+4MIh5Yb5Zu+WvMWjZ1HqhhM9dptW1sLofus=;
	b=GsNxMRwJYz2TQ8u2T2p3dpuwOETD0I+YYwIIXStGBhiikTsBurar6JXVEA/jUREHkJ7NgG
	pXfHUEa2JZk/rN6rpnkwRofrKEzx6j3F7mfVKB6LDw4RHTLKgY5ZBx7BcvpU2UIkkiSgDA
	RvoKdufVBCqGW0pd1tzl0xPqVCIj7zE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DiFh36xm;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549542; a=rsa-sha256;
	cv=none;
	b=goRPZEbBCI7kbrN92O4oKPP/jPBDM2U5cHzkIavKCYcCuEdtJ1SuA0Rk8MbbnJa0OntzEb
	kQEX/5RJNy0X74X7i5ayQapka4EkIBZT/TQw3kk/s20ke86uZ0plh38/cSVsM9N7fn/PLQ
	WRXTjZymzlbxzcpBGcnees+AtRAfRbs=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-786635a8ce4so10999187b3.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549542; x=1763154342; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b9ls15f+4MIh5Yb5Zu+WvMWjZ1HqhhM9dptW1sLofus=;
        b=DiFh36xmSLn5rJSfTaNe+sNM+LPigmOyTWXq+toSpHXJe0YNdgxmwZYD4e7w64sPF+
         ZAmN1vbYVC2UPg2TbFiY6qsm4vKkebg5fpYOvQaVJfDGUVFfijeaBP2L7yUarBqwFFAw
         0nuN/OczBKaP5N+2JRfmmGztiqFdd0UwQVr3yrCO616EKJFbjtK5a2nymyKjW2YblxmU
         LJ58/0J9t8+3bVzClAqAUr4BZRSgLRD/psMog4skS2OW2ziAPb9bXU0LFIgjiCaXq+i9
         Hvoi9zx3x+L+UbadFxFJ8I8+Mw6Hn1n9LdpbUOT0y9inGuYoPe6v0mU3z3Qva+P0RCZh
         uAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549542; x=1763154342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b9ls15f+4MIh5Yb5Zu+WvMWjZ1HqhhM9dptW1sLofus=;
        b=JH26qXyMpdqSqUB58cruGcf2X1Ji8gKvW/V/7eqXERjw9gwuuyiDVMVj25GT+alkLW
         QwTtareO0BT345YfbEBaFIZJEjH1y6qzL8UcQqUt7u3AcYLLc5cjxrbe3okU6cmfy9Wa
         Q/lbAa5IoOml4GblTWfj5HlOcsdsBkR2iN636qzTVWOfegA3am6VvbH4Fo7/a9A8d6ph
         0vBF2tbz9wEhVYBAcKDAkeHuRdVujJoR46wsGndtByFK+iqvzxRjmlGQJkQf8cV4OTL1
         NukkyEdU5IX6ocoPKr+hlyNokTM+DSxsFzvwgyGEVTy8H8TzrN7pbmpkakKRU5YvtG39
         9Cyw==
X-Forwarded-Encrypted: i=1; AJvYcCXfQo1U0Ri4xf9SVRHBAWKFMCBlFizcE9HtmAtEY6elUo7ksTlvqhNZSIrWIBiOD+4DmWiomFUKfA==@kvack.org
X-Gm-Message-State: AOJu0YyeQ2G7FnSMMYdJLHq5hLnbz1SfXtl4Vol0b/3Se2TDxeww+VmF
	XL4qQNpn4GfZnCXTNDBad9oOUEasbvFptK/Tb7BwKO1nUjF6Y/SK6ZUgTZj8AjPLen8=
X-Gm-Gg: ASbGncsltui2pI7c/7ROLWRkVBUUlOVD/QBit10hiSOVqJYlDW/rKChRBXG3UPQfbsY
	YmwrzvSlCw/Zr4Zoz+nEf+rVejD95d2CvD57tUb8yhwqHG/IjkrbOS95R7qaGrAQ5KxV2jMetzH
	syQqFTfLdvERwmOf5brLEVWDRFsj+DZJQsWw5pOn4e7pAHP3GBjhbvBRWIRh05KmHrsOw09fzLn
	4ykVXK1b+62f8DAl9qRQTnYdvz2wg6pPzL82YwUJeMuVznd3vDaMWwXcqaQKfdsfVmQxKD9bnrW
	iSpSFOb4rBQfUhH665d5vUubqnWRLze8bJ5j4p66ycVlixC9IorWuvAp7fnKA3pyfQRUQOssBzZ
	k9MhrKNUgW0yLD8VfG7iKB//WTv5G/8CA0yfa290uzmD8XlsWdvAoMWdzFoG1PVf4IkdQHKOu7v
	OzNogMQ1+gChBZw3xuY39myhtqyyFsIMrhnb0GuWPFRh4R6bDri7GEL1vGXGyEZy0=
X-Google-Smtp-Source: AGHT+IFMBy2As0ojpganARRAtGLKmm8lcgodoc22XvJ7tunGfpqLiCKm9BOIEA7E25Bvbl2mUycg2A==
X-Received: by 2002:a0d:d0c5:0:b0:787:bf16:d489 with SMTP id 00721157ae682-787d5467e1cmr5985997b3.62.1762549541688;
        Fri, 07 Nov 2025 13:05:41 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:41 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v5 05/22] liveupdate: kho: when live update add KHO image during kexec load
Date: Fri,  7 Nov 2025 16:03:03 -0500
Message-ID: <20251107210526.257742-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC42740014
X-Stat-Signature: zpqcsz65tyh1tjmb4ff9okn8f8z5b14m
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762549542-867475
X-HE-Meta: U2FsdGVkX1+RxFPqBWDbyc3CO46rhCUPaBwazcLhx/xNpJQcp4y0VJ8ztideP9Bqg30lzxE9rTp7gdUDmN2PqhfOITp7hh5FVTMnSZwr9RWXadyxefGWxqKODlzUpEj6Dl4tKae5DO9btX5VdK3aLhv+JwgSB8vESQfh4Pjce7B/W9lW/exMnhT+L5IJ54gC9cRBoEmeW0SCgXYJWfcdFPOn6Rc1G9XpEyKkkN7SZcbKLdcwRQR+WJHdojLhFSc+z8VxS90Ircpx5W9Yptz9eTKHUgtefr1maK1DJ/YbwKv3G7R67J7kv7mwEIyszFNW5JmTKKdQN7L6MfJhITC6vSyuYa2NUQGxyNbkXouH5HJrQ6zTJQsoJEnobUUNmAl0tXumivCOqT+s8WwvOqlXCmDvNER/Ws7Tj6YjYRu/RjpxatTXRZD7MkV92ihj1M2NseUyv95HgnjMp2EEZVHtL6CUAORmWAUflBowd81hjMaS4MpkZe8lCAlDtyscdfk/SK4jnVi/+FF+wtR0vIxuqBWQQ0zJCk0BZ+U5jcQr7IsXE+XMsLN7J3hYcoxrGKCtqT2nKSHLlSipJZvVGHM5tGgCKx6jVbJqt/+EWF3L0x4UtTSa7DDWZ0wD8GQecj2Jh2ZTO0RiCcr0+mk5lhL/znrEH9h8PhMLfPLBlQGmE3q7zAY3ig/PM6nST+tDJmPVfj7EZRsDqpGzZ0f9stgXWnOy+L0Bp93Qh+VlXjmKEyKYSF5AEvg6iigbM88c4KlgSHRxaSH1cJh52TRspbmlZZ1prMHQqIClx+JLKOQL2IyzNbBXPxeiy3qjsf5AZjJ4ohSoQ/aiCJ8k6MJgpEuIEclLnqvloRGlhac/rp5txl175BZGMxskcPLN5v+8Zg5FBBvMhCYgDDDhzlq2vLF8ir/g0xNMHY8hdy8dfRw1GOQKwMZ/7rOxL6xGljGBDhLHCOYKEkgEltBxBMPcZfl
 YpiJdYWo
 iF6vPZOx/koplpF2fbKZtbb9Q/og5uuUvJGNxp8OR3CEKuiwwHt2JX4MBYVtLQ3u2bbN5Q18GNaNG4spW3Oknwubxd/GfFZ2GpOKjO3NSd/8GU2fBdcmE2CBLNdB4fGfZInBcpEoXqgOjoNmcI3XFmqC7WsVfiX2lKHgEpoPGGON4Xr99Ns62FZHuf6mLbiBeUEXRWDpxHY9ZyuEcFO+B3ZcZwiVWFHkFmNicprbbmua4m0Yl0tr5gC0rLqIYfEu0uPcRFc1OPHEsFJUNoixmTkL4tkKO/nUyibezimfwQzOcvXFAO+uFHpNDpagiMpPNuLMJgdbD1apCIUP8uB6XRUpI6PDeG1KMVdhcTUO4yK3W1NHEwK6dmVLZofkFH8FvhlLOchp/OqrkehGh9VWYlwNLKClu7VzlzGiMGzXYKfO+TTadiz2I8jSwqdbyWRMMs9oXKxN+gg+pfnawStnAwcTwVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In case KHO is driven from within kernel via live update, finalize will
always happen during reboot, so add the KHO image unconditionally.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9f0913e101be..b54ca665e005 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -15,6 +15,7 @@
 #include <linux/kexec_handover.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
+#include <linux/liveupdate.h>
 #include <linux/memblock.h>
 #include <linux/page-isolation.h>
 #include <linux/vmalloc.h>
@@ -1489,7 +1490,7 @@ int kho_fill_kimage(struct kimage *image)
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_out.finalized)
+	if (!kho_out.finalized && !liveupdate_enabled())
 		return 0;
 
 	image->kho.fdt = virt_to_phys(kho_out.fdt);
-- 
2.51.2.1041.gc1ab5b90ca-goog


