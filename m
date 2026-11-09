Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF432606D81D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BZ4JZ1CU
Received: by kanga.kvack.org (Postfix)
	id BF5FC6B05B9; Mon,  9 Nov 2026 07:59:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE476B05BA; Mon,  9 Nov 2026 07:59:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3A56B05BB; Mon,  9 Nov 2026 07:59:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2FB6B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:59:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 107DA8069A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:59:55 +0000 (UTC)
X-FDA: 85415587950.12.84C6891
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B841100003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:59:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BZ4JZ1CU;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794229193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFLyLGgFG0Vde8F3up9OcQyEBIvxvgIL5mkoTy3kJfM=;
	b=X/AVuKhC/7PAtRBBaNem0aWB4iGqDNyC5tjVy+cE7LZRGMXgki4e2iDCdvppOUffddWQ5f
	puC9CK+l8gaamv3f/DdtUMU9ct+zeKfMYz+MpY6JO8Jqn72hOiq8rfWpnBZk7dinFkeyql
	ObUruqLBhzx0mHq7urxNX6SnrlKMRHE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794229193;
	b=j/v8jmBL/cT8Hwuk44wKwCV4M72rOkcWUK5w6H23SOeTYWXGY2aTnjeyv6V1rZ/lC6gieD
	ZRm7kJBQeHmyoPpZH5h5q0WcswNQi5rxfD2EISJ1wBKxN0xEarmnzusZPT9c69uKLz3dYr
	h4FYqHqWourvDk4H0l1CwOUs0z+h/Ww=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BZ4JZ1CU;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2eb14c60a7cso415985ad.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 04:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794229192; x=1794833992; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XFLyLGgFG0Vde8F3up9OcQyEBIvxvgIL5mkoTy3kJfM=;
        b=BZ4JZ1CUjDTDtl+bC4Kr5O5QihoFhxD17EqPI7NbpL7P1Wyem4n5V+j51GaYaFNbsI
         RVhXJx9SGQQA1DKEJU4em53m7VIWghRg54xkNFiwZipWtelWm4G19fi+Uc3Eybzm6gJr
         HEIpMJ8oIcQCxLB5XHiJ1t5l8bdy1gYZjgM1GbcV1U60R1l8/fGDykDqKCjAev8sRdVY
         caN9iwiRc7N0+ubPdTxteagCb8w7ZAMVvPBMzw8AqDqKbPc2/hLwBPxVQcGqa9ZJMK9d
         gS4RkYNuZSk9GeaRou0WC+ZbgUTSs9W3+RAGnIEmDgYLwO14N1mIpIqs4z3/M1L/PTOl
         FBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794229192; x=1794833992;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XFLyLGgFG0Vde8F3up9OcQyEBIvxvgIL5mkoTy3kJfM=;
        b=mIj/R1RtSoEaEfHn1gI/gNSgI9unLyxQmTwk54HdkelyR9nC06H+WhKwnaRYNJ5ha5
         orOJTsRRmSrAPqcV8L4If7ByVwvE0coos1ctYaN4yOT9+ulQMUPUkaCVSMzYFDrJngHI
         aXpsRcVF/wXIO7YESZxfUd1jNMoQlqGxIkbM7JTEVXAnjlOgyawiV9wNjRA4/88BcwEd
         pYIcWLtKgQaORZ9ZWCMnsUgxmpdKS8sL9V+qr69yW1z8mW7iheNyoSoHZO12IlqW2yHE
         pJMrwQy9SJvUcjjyKMmpPoKsXk7zMgXIwfbeIEbJmW3qyOHVznX7kKrz8pTIwCUgGggG
         YvSw==
X-Forwarded-Encrypted: i=1; AL+hErFoWQ9DWCDc5Wkr0iIGCaVpuxkAIRM+nZjYzzh7gsZulUFkhyw5wQCz8TB/0rVLHAmAAU7/hTjR1w==@kvack.org
X-Gm-Message-State: APuU4Z/ct/N/EC1fz1PD+xBeRyqJVAVhMoW+ouvILXjgvjoJZgVCA7hM
	3OIn6VMICdXOJFtRaNczDF03vu5mAy9PtrJqEgTSbhfa3tlMEtcN+cZPNbW6LZJZYus=
X-Gm-Gg: AYBFou3LPZVTh6AatM2rTpQxKgrBoCykqR5tanOi7fwjSgru86EWB2sFcEmXkwqNqzi
	7kywShCE3Ua1EqibwMg+Tm1biUKOGfJR4VbkbVpXte6u/uC19g98RpYXyb2v8SzfjHW7gJxvExj
	4v+WHWv6CpSG4ww1T5u5DzLXncUNgBc5GiOaKxaw5qePRlSdtg5Jf34s3GHgXehp/KyIZgEyd39
	4njorvWlwmdY1c0ZkZsylMOtIwfinjGowg9TLv37OhH/jZ2JLBt5ZUyBC3zmi5tVVLWqPgMvHlv
	PyJYOl0RciwbjW4sTyrXGl3dsc6pLfBcW7/bh8z6CFd3iT/PhAlitZPph2QQUbxWCRN41xW1nVO
	hc4wolPGTs03UJNgzfpyNQeCirIieCPl6a+lS90rEbq9kGcceyPL8oj9R/vILYyoBQPcYX4QEOp
	0VeJEid9dyfN72Y2+qOr5O0TiGu5Qg9hFdUrl8WHO3wLYlQzk8DFFMkkVmzdMfyQOP0GSeoej9o
	hxyq2/tc7xuiAHDHnPdp9YGv8mxKH0braTNdlbi/c7Qw3XW4mP8/PO5PSC5MXTFmjvUfbX/Grgt
	GPfijA7F1UuUayK8fOpgPXSBtuSSXur4sTuQwXbWws0nArRWNJB8Dtr4zjAqOAw/RQA=
X-Received: by 2002:a17:902:d990:b0:2ed:2a1d:e36a with SMTP id d9443c01a7336-2ed833c586emr61760975ad.1.1794229191555;
        Mon, 09 Nov 2026 04:59:51 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb969694aasm1534153a12.25.2026.11.09.04.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 04:59:51 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Mon, 09 Nov 2026 20:59:30 +0800
Subject: [PATCH v2 2/3] mm: remove CONFIG_ZSMALLOC_STAT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-zsmalloc_stat-v2-2-caee41684aba@gmail.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
In-Reply-To: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: hgu95dssk9cjzresj7znfpd35dpjnu4q
X-Rspamd-Queue-Id: 2B841100003
X-Rspam-User: 
X-HE-Tag: 1794229193-823678
X-HE-Meta: U2FsdGVkX1/SpPp7RzXuBAfnE0fxIeFlavftDqqbljFqhtcd7ajE9fnn8qdKLrRZSWGpPTEGIkLzzVXmykEVulg2/oUOrop4AEG2Ce8v7+Stk9OgbMMI4eWfFUrWitkCIZPbQmpldD6Pwqcde/a5tcgF3Ax3e3A0hz2eOdaKK5iUcNzz1BUpPXp6qNvzKbEeUrJCQLqoLaRRcWI9ngwmf0P5YBslV/KphpcyWYJAdHaQyRTDTItvVPYB1u+i2w6u50ZgXUkGqPjDz+RL5osPzyEnj52BSaYDV193X7sDWQsYXJRKpOaX7MOENVRbLhNIuBETs4z6hSqKhfFr5dbOuz6wkioE7+kvl3xkifO9mynXKxzJyCBKEebKXZKrZ9JJk4J5DfJSLDNoteoN7xnVipah5IKIbLC/Cf7F5bQVxsd8tLIMxA4kAcmYwT7tuKeGA2+dZ9CaPjaUKq8kapWIt/GH1WlsytoLAhSyHSMMTR0sU0kFVWPsHI4Dda7FY17vWNDN1wuzB7Ae1wU2Itgvkl9eIIxcXPD2pBmmEpzJySYXUWvPAGeA1NtolBNzXdPkeXfK5e3pm4GptSbN0ez76MtF05As9DiHh6EI78CjJ0eHYSjoCGwYAsNfUXHosf0HndOmzsgAIIWPpslevPf0VhO4xygJEVGxIrAg+bmc/eDxmG1bv8EC+hXG1l/M/9VJHCX6AzHdKObVhOccrnEF2aCzG2wVlZ6/IbtM6GoDJr9uEiQieUpkEKtvhqECDlCeZad512tQnEoB5ETKNlGvMrTT2EXfsISlXEjJphQHpHD+bvVx9auLWFGkVNLInCyT8lsAhY3hO/fjUWmA7JsQkzK/Dh/lEovxRFM/7mvuLna2jXbi+90+uGiwvZsl2meJlXUYU+Xp0kG+6VDGCS4+7H5sK3TkOACBceQ6NFF6UJ04loFWMl+diNjhfME/DMrOkktmQxOolyyhjTitTae
 5FsOfH+i
 5nxw5G0JwOhzPU3ZsNgrQmKJMDqGkMoSNUuZ6AHE1lrvNPUvemTm4HHcL2Vf2zIZrmv7KaESarFo6fqMjUq7b3MYzeRiVilOqnlPz/X0SjXK3Ef01n4xXu7uvA5/E8gWhI7YBsRtKxrqBZ1lOBQUCCC0rsU8b1bShFM0yMJv+69P7vlspJVm4iLQ98ahcvvieVUoNOQIsa9GxEjhZjQNZi5PvcGZhrxV4uOEJWZaJIGGbIV2PNKKTPXz+3/94xh0SBmRDrWIcX/GyE2u0v1qnmC02UGstlF+XBe5SZDhjQLXSAKIRgC4/6P6pOFk5meIT7s1jXlowdDybVabdlsl7VjrUY/73zeH9QzlCiTzT5w3YcAwtHRtaxufTWtk0omQtcGhztmsQFAszS9jNdUKIQh+gtPxzSzK2NGazg1sxXo+ifQ14hluSqtItm3uCUKADtfliVvnHWOaT9z4TRedmco7PBa9DhojeN3+qp+d45/N1K8qWPKtZwexSgScG8xQg99WrElBXeaSsnOIAsG0gl/IA+Xa17xIt49LDIeXaLUbJUNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The statistics interface now uses the debugfs API stubs directly, so
CONFIG_ZSMALLOC_STAT no longer controls any zsmalloc code.

Remove the Kconfig entry. Replace the remaining CONFIG_ZSMALLOC_STAT
settings with CONFIG_DEBUG_FS=y.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/s390/configs/debug_defconfig | 2 +-
 arch/s390/configs/defconfig       | 2 +-
 drivers/gpu/drm/ci/arm.config     | 2 +-
 drivers/gpu/drm/ci/arm64.config   | 2 +-
 drivers/gpu/drm/ci/x86_64.config  | 2 +-
 mm/Kconfig                        | 9 ---------
 6 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index d44674b63715..83193ef8efb9 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -100,7 +100,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_IOSCHED_BFQ=y
 CONFIG_BINFMT_MISC=m
 CONFIG_ZSWAP=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 CONFIG_SLAB_BUCKETS=y
 CONFIG_SLUB_STATS=y
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index e00e252d4694..694a309377d5 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -94,7 +94,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_IOSCHED_BFQ=y
 CONFIG_BINFMT_MISC=m
 CONFIG_ZSWAP=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 CONFIG_SLAB_BUCKETS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MEMORY_HOTPLUG=y
diff --git a/drivers/gpu/drm/ci/arm.config b/drivers/gpu/drm/ci/arm.config
index d7c51670da2f..fc0a8a4bfb18 100644
--- a/drivers/gpu/drm/ci/arm.config
+++ b/drivers/gpu/drm/ci/arm.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
 CONFIG_BLK_DEV_INITRD=n
diff --git a/drivers/gpu/drm/ci/arm64.config b/drivers/gpu/drm/ci/arm64.config
index c46125c1f80f..10b01b55a66d 100644
--- a/drivers/gpu/drm/ci/arm64.config
+++ b/drivers/gpu/drm/ci/arm64.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
 CONFIG_BLK_DEV_INITRD=n
diff --git a/drivers/gpu/drm/ci/x86_64.config b/drivers/gpu/drm/ci/x86_64.config
index 7ac98a78691e..8225b806dad8 100644
--- a/drivers/gpu/drm/ci/x86_64.config
+++ b/drivers/gpu/drm/ci/x86_64.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 CONFIG_PWM=y
 CONFIG_PM_DEVFREQ=y
diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..4a77cda7f1d7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -130,15 +130,6 @@ menu "Zsmalloc allocator options"
 
 comment "Zsmalloc is a common backend allocator for zswap & zram"
 
-config ZSMALLOC_STAT
-	bool "Export zsmalloc statistics"
-	select DEBUG_FS
-	help
-	  This option enables code in the zsmalloc to collect various
-	  statistics about what's happening in zsmalloc and exports that
-	  information to userspace via debugfs.
-	  If unsure, say N.
-
 config ZSMALLOC_CHAIN_SIZE
 	int "Maximum number of physical pages per-zspage"
 	default 8

-- 
2.47.3


