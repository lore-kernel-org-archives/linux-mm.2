Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0655D1118B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 17:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41E76B0012; Wed, 26 Nov 2025 12:46:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19696B007B; Wed, 26 Nov 2025 12:46:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56BE6B0088; Wed, 26 Nov 2025 12:46:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9622A6B007B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:46:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47E3F1406EC
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:46:37 +0000 (UTC)
X-FDA: 84153488034.18.16EAB01
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F771140012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:46:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764179195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=ngh5WCQQNN28DIPnbePNrqfYLwUi0/9012QJtQO9mIo=;
	b=TFWyqquSeRmUarNotVtZf+uo8MQ0YvFMRHslnfcjjAhj66/b8XBSN0qx4Uob/WjTEhsXeB
	46tE7vXGSUWfZNoCbkWKI5q1JuVUOzbFrIq4F6rKtoRX+Cb2mK1XRq8yqBxn7QYvrNwuXe
	2oyG5MNdRu1uW3449K2FaJVmwTdjLOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764179195; a=rsa-sha256;
	cv=none;
	b=yYN0qc7oYX15FI7+ZDZUti4itXCOx0Ccr+Uk3a5TVn7qRgrFwNL+/IvQ2zUNot/b8gqJt/
	H/FDRuKNSYltuiN2tkcxz+iB5tQpt0OnIDoluw4LC1fnZIxRVf+Yr7gfYxQ7a/ZRBAN/ii
	GTPARCyRZZPBfJ4+Ad1yRENHToHlxWM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7c6cc366884so30561a34.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:46:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764179194; x=1764783994;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngh5WCQQNN28DIPnbePNrqfYLwUi0/9012QJtQO9mIo=;
        b=CfhEM0cBZcvkxjulMqXNfG1ILcTKu1tVE2wrn2M7PGE25QYxkMKpS7+/KkBZe306yR
         s+Y32iIeKKmmD5ewopvwWxCLEPzxt24XkAaFjbjywTPPeepxOMtLcmlUmHNXfeHwjsxj
         TEhpG6uwSTk6pI3Ce2Xgp5Fc2JFiMOnE+iSyFBZaS6AMB9arGEeP02Cn5ejvcvner0RZ
         hru8wDW3khaAMxCrJXMrbpbsxm3cP2KH1T/x3cJkQGTApndKPG95UDRfh5L+9Wi9hIpV
         Pxy1AE4GA+qevoZDDLH+oCBP75+0Q0v2j+tSJ89R8ANSPF9ZEfrc9AKu6Wg4LECxeaFe
         LCSA==
X-Forwarded-Encrypted: i=1; AJvYcCVVc2FLJsgByVNbP1zEzS4xgh42jewFWvGTC1rjmXKJ+s/dYnoAgaigV3KnVd7LPIdO2NOexDWxXg==@kvack.org
X-Gm-Message-State: AOJu0YwetyKrP+DgtGWwjjPD1rY5yKX9nCZYSydzLzrFnxGQ1NJRFjwc
	dZfCcNA86HigAPVpbFJgeDo/KRGQ0k/dCKvJnIfdY8/rkQByEbPvHQAc
X-Gm-Gg: ASbGncvzHWor8kt9+4cuLY7/+NYUoktcLGkUICbDAv+fhICei9R7v4arNizLsRBKpr8
	W3G7/oRxQxD9rtrJhRD6ZsYDirZX7cbPiLOeR8xIXHS122a5VKXiN+6wSRwjikonsT8CmukqJOj
	PYLqlvCYeOnFffk7axNmCxi1Lgx6qP5kwLI6tGMmdSWn2hPB7wn8VOk53TexfNa8zzIXLnTz7hw
	94oTDZvuiwUI/hl1MQNcQKDNs3eI+RJvJsuMPtQoO4+MNyz8RcYm9s4Uh02eMCy9s5YLltO3/i8
	x3zTe72d6tsqBbTKF5MR9fuoIZmGIsUUBK0CoHp/sm/PAaGx6fuCH0pXoGOe36Y2GcynDoPl/VS
	LnXfeYwgTuuEWwHLWw8J2Dwwxx72bJ+EwLUO6hEJ3zVZCuCknQTR0IojgouTlYOgBcJE6XoSptT
	1l+akr5FT7wzx0bQ==
X-Google-Smtp-Source: AGHT+IHQtRk3cqHVtBwOM91S3QDUC4t4B343tUf0oWTeq8a9iKRiUd9uXUElLeAEu3SmK2f131kv3w==
X-Received: by 2002:a05:6830:6751:b0:7c7:6c4e:ad2 with SMTP id 46e09a7af769-7c798f9e05fmr8496172a34.11.1764179194223;
        Wed, 26 Nov 2025 09:46:34 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:44::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c78d302329sm7761526a34.6.2025.11.26.09.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 09:46:33 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Date: Wed, 26 Nov 2025 09:46:18 -0800
Subject: [PATCH] mm/kfence: add reboot notifier to disable KFENCE on
 shutdown
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-kfence-v1-1-5a6e1d7c681c@debian.org>
X-B4-Tracking: v=1; b=H4sIAOk8J2kC/x3MWwqAIBAF0K0M9zshtQe6leijbKwhsFCIINp70
 FnAeVA4Cxd4epD5kiJHgiddEcI2pZWVLPAEU5tWa9OpPXIKrBoTnI1utq53qAhn5ij3Hw3j+34
 KGHzxWAAAAA==
X-Change-ID: 20251126-kfence-42c93f9b3979
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-a6db3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2763; i=leitao@debian.org;
 h=from:subject:message-id; bh=9U+GnrSlG5sCxW9pY3HRrBJ7UI24sm2FPtmuWSKIX9Y=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpJzz53hh71o0dkkgQFrG2kU74cUuCamS+nyHar
 AitaN7UfBmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaSc8+QAKCRA1o5Of/Hh3
 bddLD/0ZiqTCTHMsIVZgo/sRS2o3c2kxOP8WK2lZX7zOxZdIUVFdd7ttiVQk6+oIvRnJ1mC7qYZ
 r9TZMBjc6E4WZI/P/iyRUxUC70JfDQs5mhERpJz+xWX4x7GcB2R0HymsyOkKa18wLCpuM3emKMX
 wv7rzT4xwoaiY6KVRkJr+YMLm4XWKRDIHcfg25U9khuh9I21EkHAJSmGEW0Rpp43h/gW0kTEaMv
 /mtMN0PtQZrKzsKJcNawEiornCfbPvUfoZ+GN0vcgJD7WzFNdz5F2tXtik7SRALjOXju7ABthTY
 xz8MAhLuGM+62d4gY7bPKrOwjOAaL1HFj5zdGKUXNvlWkXBL1j3KPMlDgUvdnMT07QlUu43i2aX
 0oN8rkdKyG8JHEhJwCTeWbANuwCLHEXltDwBWfoRoA97/RtVCQ0s3X1fVt5bgUBINMd10cjVKGM
 i54kz044jZeCJcIxr/Z8iF2uUXQAuR6QptQsf9yOrtFbC42Sply8HtAALjc7/STmWOjUGKAQJbb
 KnMU3RYqZZRhNmrv90GeEKhVp8WzcQd51JoQiDS+tVzETKzkrCGhjUgAcUXWbJZTINVVA2wSENr
 A6wG9LBV4aAkQi48ioTbXCXgTj7cPxlDp8KZOiXy37Z0Q81ZOolT2JEnL8JGqn2kOAptNBm46ng
 tT/lpt3LrS7mibA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F771140012
X-Stat-Signature: oykugiryfj64wo369udb5ocuefkpypzk
X-Rspam-User: 
X-HE-Tag: 1764179195-169723
X-HE-Meta: U2FsdGVkX1+1RrGXf8I62Y5G6sdm9duQ3ebwsCOEOa/pgaMw2POmaVNCIMFpdTRuH3hgu+bcmrwqrlHb+hY0g/Mp0vpnr2YSfdO4VmvsrkYeoP+lSjPWwjX67E6gtUCvcrfPsK4b85eb2MggbPgo114u70dj6dwGo8X0pYxQbKsiwZRoE2+FTaru2mev+QMFbRDdx9/2RVGojDT3D37VUYUkEI/ez4tU8UTzHaK+YV87XetospXm4ixc6I5aMBXyDvU2R3bA+P3V1LgPEX5hYhfiXy9k1/L9jqfFA+Qa+vWrV85ABJ/jiU35OxNOvQNhfFkagLLXB8vuyo56vM5h3epMDm5ZGZnL7zBGl6Pb8rGPC8tNbwpaeJ6H54tvBCxiRK1Hqizrsh8MOTyqRThDF3B31PC38SrgsumfstjeMHQ+yPlzFPl58esk4BIfxlOMvlNv6UqXOV1qRt7VDfbCLsrou8nQGzkpBYeVWQBaeqg9h/SnHTGrkku+6qCJMgtSjtt5pDvLxRxLG9v/432C4Zm5aVjQdaC6WQYiN8dF4NO5kPoIdMvhQudWV6GM7Dvz2bImpRQwTT1KDgsEnDEko2gPLcLUXYreIOqP7hVfw3F4TkgR1UDYgOi9BybQb+JULnYOe+cEZPYF4pFEN8AbDhpojtrJScszUWGZpv1iOYj7DJsrk8gRJ1DvD7y4v04065bEFcAUt9SC8vMOv6TKgxDPPVU40YLcXFroBhI/Fm3bLFAG0sAFqQsEdClTTUSeJ+1tJ/dXWvch2M63cuDi9UbmfwLGtAYmKrQQg+9S62oo2Wb0D3AeIxjeffemaWklsgXvIMD2Fzr0e3zaJ/+44DSMzoHlpttGS8UlzZaYm598cfl/SVz5kfIFq+3NQ6Hcrf7rKXm7Pa6NsGuAzVRHCzhdJr0s1XfeRZp4xVzNQTSmGVFHX+ZGdDrGSmwQB33/3QgeNv3r5j/Ed71qAnI
 Qt+7K7Yd
 c/jYt2oTeBpVQPvi6yXrbPvwTWIYygiJTD97u8zRq4NFUE4MyFXz+uSeOhHeF0BS1sFTQDJDaAY14e4abpTaJNffa2enFTdKuDcZm+H7IB86B8R+48HmvkdvW9h5pqU7PaRIXMDURXKyiR+Y/efaU1ePLsp218O6cgs8cW91zY7dAUr0SRp1NXDdDz3u7enb1RuLkBs9TQAxaF3c8OBLGeu9ryIbGe3pt40v5zdJLR+k15toD00UasNJwxyDMXewwAjHZR/miqV9A9rop511Ky7xLK/9Ir1gd5GOFfM0RnmzLPqxRdftw2eVJIJigfuy0ARITFtOFa+xPS9vONNipA0MMsFAxNefWdp9acRnygRvwGD2Mz6gDvy2pR4lser2/k9xP7/r/pJARbZRabX10czDvP61w1jFe7f3m067pNcDJB2qjLPeS+KvponSRK2viCJ6wll5xi1D26t2IGg/ZJQ7dfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During system shutdown, KFENCE can cause IPI synchronization issues if
it remains active through the reboot process. To prevent this, register
a reboot notifier that disables KFENCE and cancels any pending timer
work early in the shutdown sequence.

This is only necessary when CONFIG_KFENCE_STATIC_KEYS is enabled, as
this configuration sends IPIs that can interfere with shutdown. Without
static keys, no IPIs are generated and KFENCE can safely remain active.

The notifier uses maximum priority (INT_MAX) to ensure KFENCE shuts
down before other subsystems that might still depend on stable memory
allocation behavior.

This fixes a late kexec CSD lockup[1] when kfence is trying to IPI a CPU
that is busy in a IRQ-disabled context printing characters to the
console.

Link: https://lore.kernel.org/all/sqwajvt7utnt463tzxgwu2yctyn5m6bjwrslsnupfexeml6hkd@v6sqmpbu3vvu/ [1]

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kfence/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 727c20c94ac5..162a026871ab 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -26,6 +26,7 @@
 #include <linux/panic_notifier.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
+#include <linux/reboot.h>
 #include <linux/sched/clock.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -820,6 +821,25 @@ static struct notifier_block kfence_check_canary_notifier = {
 static struct delayed_work kfence_timer;
 
 #ifdef CONFIG_KFENCE_STATIC_KEYS
+static int kfence_reboot_callback(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	/*
+	 * Disable kfence to avoid static keys IPI synchronization during
+	 * late shutdown/kexec
+	 */
+	WRITE_ONCE(kfence_enabled, false);
+	/* Cancel any pending timer work */
+	cancel_delayed_work_sync(&kfence_timer);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kfence_reboot_notifier = {
+	.notifier_call = kfence_reboot_callback,
+	.priority = INT_MAX, /* Run early to stop timers ASAP */
+};
+
 /* Wait queue to wake up allocation-gate timer task. */
 static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
 
@@ -901,6 +921,10 @@ static void kfence_init_enable(void)
 	if (kfence_check_on_panic)
 		atomic_notifier_chain_register(&panic_notifier_list, &kfence_check_canary_notifier);
 
+#ifdef CONFIG_KFENCE_STATIC_KEYS
+	register_reboot_notifier(&kfence_reboot_notifier);
+#endif
+
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 

---
base-commit: ab084f0b8d6d2ee4b1c6a28f39a2a7430bdfa7f0
change-id: 20251126-kfence-42c93f9b3979

Best regards,
--  
Breno Leitao <leitao@debian.org>


