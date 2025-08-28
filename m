Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C524CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52098E0013; Thu, 28 Aug 2025 03:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02338E0001; Thu, 28 Aug 2025 03:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3608E0013; Thu, 28 Aug 2025 03:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 73B5D8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C4D41DEC8E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:47 +0000 (UTC)
X-FDA: 83825354214.03.08522A2
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 73378180012
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fWF/rZrS";
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7709ieFUlS+2MrC1zNfTfKDbThJkcQv3sQ/PEEU3R8=;
	b=XzlBEwSsCnwl68JffpdVoHM6XHOP5VllKCCSZxgHBgHmJ8h5SrrY7Fdy+/RwbJwW8k+Dgr
	bNK8PuwtM7B7PwdCeXtk0T74/2JNsjzMMsDNJY8CeeN1Tp57vXga+YYtPMYzJ6Bd27F5vG
	/sFfcwO60vObIx//BHP/KdzUrw7lDYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366485; a=rsa-sha256;
	cv=none;
	b=7ukW/Yv1m9KFGNIRr/dMXoDyUYPzepvUOXwg5f/9vWW74qJ0Dbrl5UTnfv8pHihozJuwnN
	Egtv6/q4V7ldq0k21jzvtFHp6Gs8z/vsYX5oImKvLAvWbHcmj45W4uz7T6GCTWCkpWG/bO
	Yg+yuxu9WjK/6LJRsf4NaoV9iDuQJbM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fWF/rZrS";
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-771f90a45easo567475b3a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366484; x=1756971284; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7709ieFUlS+2MrC1zNfTfKDbThJkcQv3sQ/PEEU3R8=;
        b=fWF/rZrS2fNCqrwiy4/+5XSd7VTWZg8Z3soYDlCKtgznslFvs+5YQqsVGCggmwbxxQ
         CcLk6Fg3xCKnxDzpXi3kcG1ss/4kW8XcyRDVt+2YN+MJ90CORc1G2ty8mmbr352/U4Lu
         m00r2TNnknvguswyT3SUbvn8/UDqRUDK018Pd3jsqv/SRv92dO+cpAds/Ko/qd+X0w+h
         h7RX3KgD3XUJ27sqNfbFJy+CQ9kdZcCGke3i2ZwAZlk4pGWpj54oznjsi+gtHKUjlHT1
         hFYhXCEgVEOY/dxE1xss+ayyT9VIgKkc+z/p9KjRn6+mn34TpMSWjbVxeqN4WaUU5iUP
         XOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366484; x=1756971284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y7709ieFUlS+2MrC1zNfTfKDbThJkcQv3sQ/PEEU3R8=;
        b=Kh8w4szKdMobD5n+SpEScb4Pu9xc3tzNfhBvzpfT3zBfqznAzL7S8ANLlXRZEwuotS
         xveoFDNx2VnmWVYQq/SkGpdNg8560iCPSMwGAoWK52gKTcYjKnq9v5DPZ9a4GJsZjNkU
         iaSpaaRF7vqTTV8ylGXeHKmlUGbdmFkdzq3so8W+NbQkK/cNm+Wxtn6li6DPMZJEwF+U
         Iz83rpI1hxKYJuTncYGyOhuYq9evQtb+n68PGHjoiyQNo9JcazER8RxIh7rDouBE+3uC
         XPvug0K336knKVJbfHk02fhBZp3W18ko3I9flK6l26EKIr9t56uIkU3B+0rmbjBI9ozk
         2sDg==
X-Forwarded-Encrypted: i=1; AJvYcCWMRUfGGkFmNGJ2gJ7rJXecvUOpZO/V99tyP7Iy7X1kx7tp+LrPUfCZRsub3mXJVirqeRbwpPV2ZA==@kvack.org
X-Gm-Message-State: AOJu0Yy5sihK+wYHD/RuyFznqIGZHAdUta/M/6fcC+s3i01+LM4PgdLq
	NTRi6LiAeRxNAtLNLpq88EiUjtdwEet6HlYH9GHhX4ojyVtAVBQdbGKs/ykqf1Wwz8U=
X-Gm-Gg: ASbGncuoNFGL0JhG2lQxN7LYQQHu4Xka5Wjw2egZX1+jxoJB/9JtTgcK04joWJIAPXy
	dCys6Nc8/V+7NKfinEs4ei0xMWPxDBvhO4FUfK04/2t+RLXC+/+QzSbOSWgxw7HmEd7SZojKmZi
	HEyd71qwL2craSQGS8ByJi2AJhuWCR/QddtTIUrzR/xtEm05/smTMKKPsY1oY4FFPLlt9UUpD7a
	Z+5qhPlk0t4i6O4NzNv7GEP/IJaAsI3bZlmahLkAuYTFQw3jK+h/ZB8r5sPsz1ic8HiN6J5WkMc
	+KycK99J1Chz6m/5ViwmDb8EExCP4ZvwDRHo9CDoWWO4QuvvcvfYHKBXpq9SwD16H5VodTsDqiX
	jp9YiDMGQOM08rx8hDshl1mAElUVbEVIzS8wspCawraqxnCCofXOOp8EKaDp5XocQ0BO+2Mo=
X-Google-Smtp-Source: AGHT+IEIHHNWrId/X4KeEFqzkhy9anSPZ3dizoDTWPZdjGsO5evyyrSwN6uApRA0NfOM0BM6Js4xvg==
X-Received: by 2002:a05:6a20:9147:b0:23f:31ab:371b with SMTP id adf61e73a8af0-24340b4623bmr30386114637.17.1756366484347;
        Thu, 28 Aug 2025 00:34:44 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:44 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 10/17] mm/ksw: coordinate watch and stack for full functionality
Date: Thu, 28 Aug 2025 15:32:43 +0800
Message-ID: <20250828073311.1116593-11-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 73378180012
X-Stat-Signature: 6cejyxgo13p8bf87rar16prbenyhm5dr
X-HE-Tag: 1756366485-407434
X-HE-Meta: U2FsdGVkX182BI9215pi7ed/vlJAVtPfurdNkzUdkhTfiE97tdJyRxQl8/B+iXkZIMcyME9Mw4jFYCkLfnTNJj6C0c7TopgVsewPgCj7MK/a/Rp9EQuUmcSt/AP87sAdIIh01ZLHSc7tXoFqFO/RhAWSr30qgkHvk/XC9apEYwe4+TyUh+YKzo7ABoVpv8AhVGdNjRGJR3fDPnyU2nag+UiV7E8B4vdsWi/gNzaGuEFhXOadXgu/exIsUI+Aj/ww+1sWpqDl7j1Y23beorfbcxmJU1P2+IJ0djXWRhAf8N0eV9IU+0R/qFwgY766ByDOhndGCSRts54hmcYSLzpWwyvitnWkC+uhMNbCn7uaCvo8vnNP/+n8b9iqGw7G6eHlyMbyDU4ypk1uM63T9A0+lXiuX1bqdvmjhQDnN0BO8toYOCakfDaHUEfxz3/UlwpgQGn6FXSEFwS2YbtKyKgXvXWWLHBxdnChmf05CxgJ78TW2vFhJR8FQhM7EKHLTjqeWaD0osjH8fhjFZAy9ga/1AfbyvGRM9iLHJKHmiGGYQqCxpDnBZfSfYpT5qmAOUh61l0fA9u9sSbxa9q3JGAQr7N32YRjdQA2lbAlQz95//6b96K+Ky5YT/DgQffaQFsL8+B3s2gclaIZsglPfTUXzBna+LvEkmYayqPG276u3C8QvwYZIt6WOiwN2NStDa/uN3WzAF22vKhodg0hzdHQ/t5RF8jSOJzQ0IDHjdqaJ2qdq0UWC8KEbzBMQzHu7hr47L/uNdzZ0RHHlyNqnoUWd1/twCWa5WrLOmIDrLRSTfH94zaDSB1MIqmDt7X49kAhzPH2+ASjr8G4Tp0aom09Ity7R/C3CawE1KB4CrFik0OcMCDV82SZeybpt0HV3F3NWrRr3ry5d8W29AJq5b7zLpFBEotdjNYxj7WmV7jDOQwddC21mSl2+Ztn69Mv+KnGPmyfmUGsSXvAhtfq7hI
 OkxVVzHW
 6pbd+qC6ilGpDYXBud1dOKnfhIVgMGwnHB/xl6QloHl5rNXYAkBA78o7H8f0kTXSrOsMwj8olQB2SBqWWdB8I6xRLrXB2qldLoJFDp/Me09MPojpqd7qgPLvdmSqu0dSpnzae4O18Ur7m3ef/1ivRZDVcRkntV0qMQbtkHEXBGsyshOV6CczSg0cf6kAiXadCH5vhPYwqnJGgKLTw19PvAddoJCtUoBDVLXKBpPOyTNMndf4nMcbRNqQyY1r5A9uP2We1SJ/efrw03cYeN+jFE9TGVKqbl/FK5tTRQl6RY6K9xT1U+DB2gafMnpkMvD21wFPQcnZ2kVT9nV19NIS+Qr5JGsL2OAH8sfytqV7SpU8h2UecxXCjbDpykmMv1dMSiH1wLM+efhnmZYFJ6t5sxYowd/F93PwahhxHGD8GRf78/WZOkuDgKCCzLpDxxKT5lfnBxVoOMS+SsKgpE7ooGuxyWXLneO8hCfscxAUoS5pehXe+KxMTVugPZwnp2Lyos9KV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch connects the watch and stack so that all components function
together.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 95ade95abde1..4c5fbcaddab0 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,10 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/kern_levels.h>
+#include <linux/kernel.h>
 #include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/utsname.h>
 
 #include "kstackwatch.h"
 
@@ -22,6 +25,29 @@ MODULE_PARM_DESC(panic_on_catch,
 
 static int ksw_start_watching(void)
 {
+	int ret;
+
+	if (strlen(ksw_config->function) == 0) {
+		pr_err("KSW: no target function specified\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Watch init will preallocate the HWBP,
+	 * so it must happen before stack init
+	 */
+	ret = ksw_watch_init(ksw_config);
+	if (ret) {
+		pr_err("KSW: ksw_watch_init ret: %d\n", ret);
+		return ret;
+	}
+
+	ret = ksw_stack_init(ksw_config);
+	if (ret) {
+		pr_err("KSW: ksw_stack_init_fprobe ret: %d\n", ret);
+		ksw_watch_exit();
+		return ret;
+	}
 	watching_active = true;
 
 	pr_info("KSW: start watching %s\n", ksw_config->config_str);
@@ -30,6 +56,8 @@ static int ksw_start_watching(void)
 
 static void ksw_stop_watching(void)
 {
+	ksw_stack_exit();
+	ksw_watch_exit();
 	watching_active = false;
 
 	pr_info("KSW: stop watching %s\n", ksw_config->config_str);
-- 
2.43.0


