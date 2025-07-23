Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7E1C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67AB06B011B; Wed, 23 Jul 2025 10:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BDC6B011D; Wed, 23 Jul 2025 10:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F32B6B011E; Wed, 23 Jul 2025 10:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B3CD6B011B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BF5DC0720
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:34 +0000 (UTC)
X-FDA: 83695808028.09.EE2EA3D
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 45ED6C0011
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=fTwmLb4Z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282052; a=rsa-sha256;
	cv=none;
	b=fQje/nsxhoTiHbqfxOIgECWu18ec4b9rQ+sfdLYlEvLWJNePYfC0K1D0OlafHcbBm/hVGl
	FHHEBWUfI1hTyjlp5Up9LBeg2x4gZDb6Zvq7zdIZes0Q6NE0ECmgzr0bGy5aMALfuOG1mp
	pDhf0CYUl7ldSxfIKy1OCj1d+xLc3Gw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=fTwmLb4Z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FWnE5Bow2uoaZcwISvBgq/4l5cKqkAoia4t69mDLc0=;
	b=aZnuWZPm8bvBsB99zia8oY1WRy0rTfx0UMYpxrRapog3UMxL7oLz36lCrjmcCTnnMJyQbn
	U6hifL500z45YA4kHT63k9+cmDlqNVvg2DElErh9x+nfhAoh9Xi+wkJLxzaOU6n06ubDl5
	JkpTC6rl4Yyw+OXHasv1DuAj1yr7Lkg=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-70e75f30452so44737377b3.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282051; x=1753886851; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+FWnE5Bow2uoaZcwISvBgq/4l5cKqkAoia4t69mDLc0=;
        b=fTwmLb4ZV3LVRbK/1AKl3I5M/XgiZCuzvVsfMuk8mUasWKe/tMY8wo8mF0rsQuEEr1
         DgicGlRny6a8/nFyr0uqNN9EbrnCKYcLthu3KAyXKXkIT6+vbow1XsGjpaUXK62/cOxU
         VCZEU6bZcIVJ3i2xmuwu7/wKWmbpnakO6WurjRK4WiigIbfqLuB8nMb2fHnGhKZ+g9DH
         oxvltW5Aq0hV2/vXfMtTSoOil3dLcKmsE1nQwrPJ+jBYOPc8AYuG1VrSRiMnQtrO/7SF
         FG16weYJcsqSuD7I54rstHTMeTAj4DoqxiqODCp5BLEU7uvxznZUrPO7YPKNSIyDzZem
         7prA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282051; x=1753886851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+FWnE5Bow2uoaZcwISvBgq/4l5cKqkAoia4t69mDLc0=;
        b=iXZzTE3vtlxDbuhJ07WsCZwu7FpgwnOW3p9C9p8xo8Jv7t1A1d8ObKSUCIx3b4JgXq
         Ffq47v3oiPO/fR6BSyHrxoHYmqku7DQChHqz1dXdAHY554wc2GZirHpUxkGzQ7p/Y3gv
         eQ9XSUYrLVGsOLzNii+p330U7WjYNpO+d/OfnHhesaa7LTHDEg8hr1Ex9k+l9Hn+I3/B
         nNEMdh2nhrsO+6BieEacq9j7H/bNI8wj1nFsXYkY5emeB8c5xqOtyTask8XdVcqeKzDy
         rPAfXfhWY6W23jWB6rSI97UvsG7HdaSpO6pGBhOKOK5f1x6Z63GJWVjmhkopElJDgVD3
         5VsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXT+lGqnHnm7YR2emO9EsPjWWrtGYlXvzu1Ou6D2f3jhoF4WmMJeA+Aygi+9xFZpTvB2grmVHjjSA==@kvack.org
X-Gm-Message-State: AOJu0Ywr3AyAZ3UhI5BaGH9K+LCZUK3sYRsm/3KKCG8PPKp2UR20VbQR
	IvX8y13ut8wOQj0YYxeRq88HBtLe4rX+VG446UinRD8qttQ6puFPsFgnzrF2HU8+Cco=
X-Gm-Gg: ASbGncvsmmPrRZSLR3/LP+YcSMQZmPO46q3x9cZlHSTQqtnCLv9M9Dr7CixVV63q0Jh
	cXc9IM8EfGNMp885ZMskVbAzWEmsql6z1ByfFW2+hBG/3z4hdWOTSFbzFqHeTGgq6DTe1Wr+uSm
	gw0xIyYs/Dt/AkyIcvw/V+UjuqwA4/6UXJHIgzgcIydcHsXy9SWNs0UYmCHmobgX6v012mem6ia
	Wl1IalnrFkFfV3zeHHOIZ5KEaGP/5dHIzuvekjlrayzklU/3x+B71vNwawsTcGEwnMPd3EB2B3b
	xch3EcIZTo9HD7lEhg0NZJqez2OKg5vwS4evEbz1wItGt5bxWCQjAfLQeNz/JE1SoLmw3UyUqxi
	aaCjIXKfOZvUdC3Lmbbvt161yd2DjoSZqSI/unqa178sQh6mYUP69Jf1o07mCu/Kw8Ln1K7j95p
	qlKAjJuEwoJIWkbQ==
X-Google-Smtp-Source: AGHT+IHLyQqcsnOqnRO6HNMaeplbRrfZNdB8+kP2xWX2qbNG9/moHQNfSe1QScqIpYGuy7dJX/Q6FQ==
X-Received: by 2002:a05:690c:d1b:b0:719:61b8:ffd7 with SMTP id 00721157ae682-719b422f811mr42827367b3.16.1753282051271;
        Wed, 23 Jul 2025 07:47:31 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:30 -0700 (PDT)
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
Subject: [PATCH v2 18/32] reboot: call liveupdate_reboot() before kexec
Date: Wed, 23 Jul 2025 14:46:31 +0000
Message-ID: <20250723144649.1696299-19-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45ED6C0011
X-Stat-Signature: 9ojcsdugyqt8cf4g1ucc7w3kxijmynr1
X-HE-Tag: 1753282052-19327
X-HE-Meta: U2FsdGVkX19HI5WJCjuvCVbc20fwh0AHSvKmPKlLGY+4zqDLm+BaATiByRh50S1VKPT0O8agacG7ZEBtNk4Uya57qHfZkMxKRK7jy8wxBFsdxTQY/ToX70xCsJX50TwTfUUfonch861sUXzn1ARNtUL3qdpf6yZ9MTywyo840tYo9H8XjouSKHr3g08nMJMCOzN/bxh3lkX4Pmj21L7ch7SYJX3j1gXP2MsucY4pRIzfhVikErmfLAzLtlnpgVS2l/OsEwc1GwBhj+xOZYzjZ65A3j5Mk0KZ4r2F/qUX22H4yylcQBRGhhkdozZr6cXTO/qKBWfj8sDQzCL/nCM7aMmqWV9GlPWerMgO2U/lc51KzjN/lEeGizM9duIIhA/wiTgNjtR9vDU8pJsIupIbM4wyMcXAjJjnec7nq32bhKYyRnEiYdzyZMsBng9OKyaekWpc8LbYTzTBCd+ZsOAipB65XP8l2mLmTgzR0qSBxyv7PxiuCe1+f8jiQAU3lOHXaYfNNfPGTGg0CQihRiejdpNH0U8eGHLrHhHfx5uIOlky1XcZTyx/+oCkwwVlORK+511tmjxHWF7ZDO+rwdn93d9HNcDBcD8F8BvmVxnZ16GtTFgVkYb/4dGVhtipWPBYCReJHFpUrU+LvO7t4dUWbSa27Ll3E9tfQ3EHoKHWy1b7hzAay8ppIqYGKF7GQXhDVnqsSCydtBqWLKjEZkth6zsTdJZoW9I1BY7QmXQ7d48imhBe2XcJcvB2aaaXnbtcRiZq7v+tuYCtPvSIUSqvyIByltL1lLOMJtPUy7pu9xQxownI56H16pgeOcVICIaQzYiEJgYJw2w+3oUQe6B1jJR74Nsi1P3WKobFlPDjvzeDhZ+R3c9hC+dU/mrZ+7my2AKPKmDYOTZDJMmvZDgPvGFXvsgFs7ZNKf1zLA5D9O6CFKq2Y//1GXZ5/yoxk+o2/Q1YyL5iClFFYiBzqOT
 r9jrpYLO
 72Go1BSedJO8KMG2ZidztkEE5Z3yU8opQQXZKpKyrwvmSkwG1bv23mMvwLvO5hZLYtmWPN7WPwYtI9RpY5Yef5H9VL6IP/kbHLK/EV1Cp1MCJ8D4ZACnrI+/YAhDsuSd3l3mEmBCqCwToiX0efpea1j9IDwrQrAHsoHkFy2W7bK8UqooVEBR5bqiL0XnWyTaFA8iaInMYZguxh9xp6zvP3xJHGhlF5LcYP9C/bCj9JFsLXRHjIS0+fHtZ2TV2tA70IPEL9q9WsmtWTpiy/Onha5ivi+x4gLTEICg53x6sWOsbQtBt7fjvZLVCWdcxEel4/D6xYnk4keOz3RIXFnav8Bk8Q+jEfXOvS1EGQ+lcMfy97htepQPMQGR1kDHkAKJG9KiEMeZ4qkFeEhwuYumY0Gq9xW1uswtUFi0zjIMnHAMnw200kAWccH6wiCe/xIo2YP/AtnuzR5QPb5l/gGvh9IZ+D1UYcSYtEzgFDtlghO0V1EinMQV0GOvmOHMBK6Og7CkYvL7yB4UroFwQvTyZ+KUQ9rsU7MkXxUkFakErCl6PKGkgRmJxA/V7R5ATZPpl9ndoKz1IAGx6VH0ga9jiuvzcMa3Rhrfn42EMrWun3lKOXsQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify the reboot() syscall handler in kernel/reboot.c to call
liveupdate_reboot() when processing the LINUX_REBOOT_CMD_KEXEC
command.

This ensures that the Live Update Orchestrator is notified just
before the kernel executes the kexec jump. The liveupdate_reboot()
function triggers the final LIVEUPDATE_FREEZE event, allowing
participating subsystems to perform last-minute state saving within
the blackout window, and transitions the LUO state machine to FROZEN.

The call is placed immediately before kernel_kexec() to ensure LUO
finalization happens at the latest possible moment before the kernel
transition.

If liveupdate_reboot() returns an error (indicating a failure during
LUO finalization), the kexec operation is aborted to prevent proceeding
with an inconsistent state.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/reboot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index ec087827c85c..bdeb04a773db 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -13,6 +13,7 @@
 #include <linux/kexec.h>
 #include <linux/kmod.h>
 #include <linux/kmsg_dump.h>
+#include <linux/liveupdate.h>
 #include <linux/reboot.h>
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
@@ -797,6 +798,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 #ifdef CONFIG_KEXEC_CORE
 	case LINUX_REBOOT_CMD_KEXEC:
+		ret = liveupdate_reboot();
+		if (ret)
+			break;
 		ret = kernel_kexec();
 		break;
 #endif
-- 
2.50.0.727.gbf7dc18ff4-goog


