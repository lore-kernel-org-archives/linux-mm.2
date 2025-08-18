Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36292CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4078E003B; Mon, 18 Aug 2025 08:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74998E0003; Mon, 18 Aug 2025 08:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A164E8E003B; Mon, 18 Aug 2025 08:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3B78E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E4961408F1
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:22 +0000 (UTC)
X-FDA: 83789806044.14.3C9177F
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 69983140013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DM3N1mRa;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d62UfjEuqJb2ik1nJ7zN7GvoCBki3/T0lP0cz4BBeFA=;
	b=2ryWKcWRmce2SjISn/EIBehKMBJkp7xOe6K0k/BR6JEm6HUlXDke7FNCxjhh7Dgv4fn20n
	ckt0hYfFnPWtX7pd+YVHgCRMrbUEzaUKp4P1FVKEpLjy2xVelDCXsdCB9ud6K3okg6R/Lx
	Jmytykm52Ws65ghicDgHKerRfK9CQ4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520100; a=rsa-sha256;
	cv=none;
	b=xuLLSSDkvTtUHUWSzSLuQUSNJiiMy80dwyu8A1Cl/3RoiKFS86jOGwrcKkJzGspGI+qOBs
	HMTlnKntdhOsi3vH3ABwrapZHFwE2T8pUMiMGi+HHnbJcLTwsXfNYWXTXDJeJId88uGX4Z
	oQHRdWjKFMdXWXeQt1J062TWDOKpNlM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DM3N1mRa;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b47475cf8eeso519596a12.3
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520099; x=1756124899; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d62UfjEuqJb2ik1nJ7zN7GvoCBki3/T0lP0cz4BBeFA=;
        b=DM3N1mRa+WySJP21rdCAVxI2fpCt5M71wOpxT8mpMLLwpkb1xN5prxzTPGnySvso9L
         KZzeCdhh4zM9J5/aHqdEVjZDtBiEPK9DCMPx08epCcPNi3HchfvCVekNbxnGL7YJdlSU
         4m5sr9HjsyedLgRkPh5fcyig/55UEndpc4L3yYNiaI829GMfN3zwQ1bvLr9Sq+hnNJBl
         t4gxWxSyBLxCe3vsrZlYTfmSh8ZDB56IhVLAr0RWDYrb18rmmE1x7eHAfYAOiFa0X64O
         +WWhdy5YoZAoWD/K8aPes8+cnYiCL1MOKYUAH7Jy9X6rfTWxSwW0t0ZvCAknJYJiZ63x
         9gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520099; x=1756124899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d62UfjEuqJb2ik1nJ7zN7GvoCBki3/T0lP0cz4BBeFA=;
        b=UGoEVczc12Kj9DWczpFwiaP0MBTEC2rBPGOwF8wOJcl4KbQhK+zMDEkGuRWCU9Npsc
         i7mW/28Z+QLpH+L1d7QaC5X0sgb5/np8n0/yK3xGzOsvkyA8/f/GcO2YGrZ+sX6aIO3W
         kDOdvUnfIGA4jGI1Tob2uuKfcFW5PwcwHpNI/NpzF/sMOTfCNPSPBPCTYyDlqAHinO++
         o3DX29e1xI+OPRqE8vQozZ6sY64sBoGFfM89+hO0/qUgFdPj+LsjDmgVfDSq95xzsprJ
         k2rNvPGUzVsHGBAcVsVkpu+WfqgaWKEvw+uJ7CaD3O4Hpu7dYke+8pYzKLlYPvxyW98b
         6wGw==
X-Forwarded-Encrypted: i=1; AJvYcCXIIglZjnVIn/eaFRRMTLrY+9J3QkMV/zOp+hRC20+URaSbFrOCaN4XKSj9AXjrxTcjtBgTHko74A==@kvack.org
X-Gm-Message-State: AOJu0YydIwTxYvvSgHec/CVVywRke/6Rw6yX4oe5vvdkr/IcyyI13imu
	qSoKd8+khPGftCwK0Efcd3XTUH/ObcoWQSx1AiHxDKDJ+7gC4TErv2hP
X-Gm-Gg: ASbGncuaKQR+LrTYs74qxnHl/M6c6v4Gj2nQDcAGnfVYM+CUI7vVKlB20CmyUHftLGF
	L6s0wyWbamL36e4ikG7oMCnTB6GMY08F4OfAW8gPOlbi3N7QV9QEdB5RPPHrotph9uTcRS6rLTD
	K9dPmdKsbuFusxqvEriHj37G6A4k9NwFck47A4+qKislmhOJFSTCq2ipTjgNOCNgtn/wNowwME/
	1Cy/4uR2b8uBiUAsyzMn7oMXm4FMuEWHt6BX3pAbb0gmVy3UynPBM82W3GJa5depkbSxXTtmKbT
	stia6jG7XmZDb/pPIFmI4gY7fkKvHdIqqulW8oSCRKuE+XXCHCNNA8IKGaXTTpl1dXtFL2p6Tr6
	UVuVVswMQiEss1AIUWK1J310YYqAzfgN7if6oCMNUm20e
X-Google-Smtp-Source: AGHT+IFVgokmbj7zixrUmyr6mqgFdp5fTKIbG8uIlrtvE5aDwip+8gjtzYlDymfl75UapvezAXvMfw==
X-Received: by 2002:a17:903:2f4d:b0:240:640a:c57b with SMTP id d9443c01a7336-2446d8b4127mr172220415ad.37.1755520099208;
        Mon, 18 Aug 2025 05:28:19 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:28:18 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 06/13] mm/kstackwatch: Add stack address resolution functions
Date: Mon, 18 Aug 2025 20:26:11 +0800
Message-ID: <20250818122720.434981-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-6-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
 <20250818122720.434981-6-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 69983140013
X-Stat-Signature: 1ty5tnkmnyew74da19c1c5tewoonccoz
X-HE-Tag: 1755520100-529200
X-HE-Meta: U2FsdGVkX1/7gh1IS3CpQ1/dafs3DSl/4rWmFl1tJDK1+FdSAgZHSbayI5gKbXNeSeV7xMWoIsXF4FWVgGSGDiTNtF3hELUcnWgWaTQDnMNS/oNjXrRp2CW/i0asSR3DIcpHiQCnSkx3ozTf9TdC6jlNUxCUKOA/gNNhJ2WjaYY52ynTN+8l7ZWwImMt7lprdi9xi6R1u7BkuBKYITOP4+OExfzPTQHPedhshy/4v2XWSpk0pfp3/ynW06VUQKeSw1c6Vd5k/XYM0jpaAl89hzOv7UnzHvYEB5vdc+/AYl17Q3Q1skjPMa+4Snub/aZKfwATLzSnjUJ4rUiPWppvQu7r8zVbLihscjVgMAiqkinUhMdSYVtJ4ex0JPlUUl8ruDg1icqZaSd/HFFXLN6kStJcmhincbl9cM42PgLjJvV3suonRyhzKQp3ZTAUBpu27dAgqxFPo89ji25zjp9HVFydZGWy24H85UEkz7atCkxjtaZ2EhryfnqXISlppPOvwm7GwL3iyb9iwduRBDbd1OS6Z50Ksa6EUt82Ufo8dERPrZfZNqjxAbgE9AM/tfhT14MUGjb7hnzixzyKUaehlGCEIGYc0nbd8RFQtgDk7OS2zVcmB4tpjlo0EH46/30K7xkLCHjLf5VJtEO5/5iwIWozBYd77M4Wh78VSqrxaIQy9xvHOFsxjGyrpOVFwfa4K3lGMjn8O0S1iyiAr5D/4pDAABGmT8Sgk8BBu6ua4Xskdw1WOLcLtoUR5c1jCHR20E3wiUBEumza0sSMi7Yj8QQ1bbjLJvirhKwUspXh9hilM7L/Ko2JPhFAN7hFz4OGCJK2hm4CngdrJoEkTn5VTBg5Lws+RgMguSfPJuw/Ocih4nxTNwmmKzEMVkWmJFE66S3nV+0mJ0rawWtQPi1QlCUCtJsg06SFqv96hykV9Ltz6kw64ldRnkh1Ilw1VeBXx0+HKN5Qn5U9rUJ2r+Z
 03fw2Q4p
 JpkMZWmgVJ+VzASNEW36ntcl8I7d/LXfMSltoURewt5+h0WX2KhlUELmsY3ltLHHvZdHrRPR+xkkcHp6o/ne5SBv5b+adjJFyx8MlLtrpAVc0HgFDULpEllJf+9psH91q+WFMDl6q8nUBzsipJeo8+ITTHuHb4eXYwREFMvYAXlqd4MzbzLzci4M+RC+/PZjwnSdxFuzLuLKU267XoMDiTMmQGQWnjh/mQfBpUbMlQs5k9arEeJIsYYXH/KP6zj5V9jfVYKHfVLf6ZXEBDGNtlS39NhvPzpCJC0DR1fwMo899kbhh+801dfof9cGk44dM4A1FiVUTQ0xsm5mxgssZ+5xwZZ+bHsW4Bk9gTtE8RAdjc0tEsdmSz7uqJ5I9CIt0sv1Huyiv2qhBTRBctyFuVirN/xGnX21Blm0jAlQZNgG1qCGxZHVWqwg1KSwGb9fd44GD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement core stack analysis functionality for locating and validating
watch targets within kernel stack frames.

This patch provides the essential stack manipulation functions needed
to translate watch configurations into actual memory addresses:

Key functions:
1. ksw_stack_find_canary() - Locates compiler-generated stack canaries
   by scanning stack frames for the current task's canary value
2. ksw_stack_resolve_offset() - Converts relative stack offsets into
   absolute memory addresses using register state
3. ksw_stack_validate_addr() - Ensures target addresses fall within
   valid stack boundaries to prevent invalid memory access
4. ksw_stack_prepare_watch() - Unified interface that resolves watch
   configurations into concrete addresses and lengths for HWBP setup

Local variable resolution:
- Uses register state (pt_regs) to determine current stack pointer
- Calculates target addresses using SP + configured offset
- Validates addresses against THREAD_SIZE stack boundaries

All functions are marked __maybe_unused to avoid compiler warnings
during incremental development, as they will be integrated with
kprobe handlers in subsequent patches.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |   5 ++
 mm/kstackwatch/stack.c       | 112 +++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 910f49014715..c24a651977c0 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -6,6 +6,7 @@
 
 #define MAX_FUNC_NAME_LEN 64
 #define MAX_CONFIG_STR_LEN 128
+#define MAX_FRAME_SEARCH 128
 
 /* Watch target types */
 enum watch_type {
@@ -38,6 +39,10 @@ struct ksw_config {
 
 extern bool panic_on_catch;
 
+/* stack management */
+int ksw_stack_init(struct ksw_config *config);
+void ksw_stack_exit(void);
+
 /* watch management */
 int ksw_watch_init(struct ksw_config *config);
 void ksw_watch_exit(void);
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index e69de29bb2d1..8b558cdbda97 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/stackprotector.h>
+#include <linux/kprobes.h>
+#include <asm/stacktrace.h>
+
+#include "kstackwatch.h"
+
+/* Find canary address in current stack frame */
+static unsigned long __maybe_unused ksw_stack_find_canary(struct pt_regs *regs)
+{
+	unsigned long *stack_ptr, *stack_end;
+	unsigned long expected_canary;
+	unsigned int i;
+
+	if (!regs || !regs->sp)
+		return 0;
+
+	stack_ptr = (unsigned long *)regs->sp;
+	stack_end =
+		(unsigned long *)current->stack + THREAD_SIZE / sizeof(long);
+	expected_canary = current->stack_canary;
+
+	for (i = 0; i < MAX_FRAME_SEARCH && &stack_ptr[i] < stack_end; i++) {
+		if (stack_ptr[i] == expected_canary) {
+			pr_info("KSW: Canary found i:%d 0x%px\n", i,
+				&stack_ptr[i]);
+			return (unsigned long)&stack_ptr[i];
+		}
+	}
+
+	return 0;
+}
+
+/* Resolve stack offset to actual address */
+static unsigned long __maybe_unused ksw_stack_resolve_offset(struct pt_regs *regs,
+					      s64 local_var_offset)
+{
+	unsigned long stack_base;
+	unsigned long target_addr;
+
+	if (!regs)
+		return 0;
+
+	/* Use stack pointer as base for offset calculation */
+	stack_base = regs->sp;
+	target_addr = stack_base + local_var_offset;
+
+	pr_info("KSW: %s sp:0x%lx offset: %llx, target: 0x%lx\n", __func__,
+		stack_base, local_var_offset, target_addr);
+
+	return target_addr;
+}
+
+/* Validate that address is within current stack bounds */
+static int __maybe_unused ksw_stack_validate_addr(unsigned long addr, size_t size)
+{
+	unsigned long stack_start, stack_end;
+
+	if (!addr || !size)
+		return -EINVAL;
+
+	stack_start = (unsigned long)current->stack;
+	stack_end = stack_start + THREAD_SIZE;
+
+	if (addr < stack_start || (addr + size) > stack_end) {
+		pr_warn("KSW: Address 0x%lx (size %zu) outside stack bounds [0x%lx-0x%lx]\n",
+			addr, size, stack_start, stack_end);
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+/* Setup hardware breakpoints for active watches */
+static int __maybe_unused ksw_stack_prepare_watch(struct pt_regs *regs,
+				   struct ksw_config *config, u64 *watch_addr,
+				   u64 *watch_len)
+{
+	u64 addr;
+	u64 len;
+
+	/* Resolve addresses for all active watches */
+	switch (config->type) {
+	case WATCH_CANARY:
+		addr = ksw_stack_find_canary(regs);
+		len = 8;
+		break;
+
+	case WATCH_LOCAL_VAR:
+		addr = ksw_stack_resolve_offset(regs, config->local_var_offset);
+		if (!addr) {
+			pr_err("KSW: Invalid stack var offset %u\n",
+			       config->local_var_offset);
+			return -EINVAL;
+		}
+		if (ksw_stack_validate_addr(addr, config->local_var_len)) {
+			pr_err("KSW: Invalid stack var len %u\n",
+			       config->local_var_len);
+		}
+		len = config->local_var_len;
+		break;
+
+	default:
+		pr_warn("KSW: Unknown watch type %d\n", config->type);
+		return -EINVAL;
+	}
+
+	*watch_addr = addr;
+	*watch_len = len;
+	return 0;
+}
-- 
2.43.0


