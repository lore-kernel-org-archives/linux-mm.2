Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB69BCD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 09:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA806B0088; Thu,  7 May 2026 05:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B496B008A; Thu,  7 May 2026 05:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1726B008C; Thu,  7 May 2026 05:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBC5A6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:52:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65B01C1C05
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:52:45 +0000 (UTC)
X-FDA: 84740159490.29.B31DC3B
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id B375A18000A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:52:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=knQd2Wwk;
	spf=pass (imf16.hostedemail.com: domain of 36WD8aQYKCPIafcXYlaiiafY.Wigfchor-ggepUWe.ila@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=36WD8aQYKCPIafcXYlaiiafY.Wigfchor-ggepUWe.ila@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778147563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yWeMPigyvPYxl+60ohT4HGLws9GhFdbTgcN+wfrxMEw=;
	b=iXaCO7ZgAteHddJaFZnG/GQtWA++cBcrswtnKEV3ocbcZIlJP7WNvEFbQSw5+BRgfSwTuk
	yXgTMaeys7Ff4MC48OmLL8v5TR1hTUfrW0VHcBDJZFH0Zyug0Pjifk0SinDiZRzmp+/2po
	Nuz+gxW0BRQJRXgkYzh/y3abLhKfAsI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778147563; a=rsa-sha256;
	cv=none;
	b=toNqbTtMK/f8LK0Fupg8bPehG8FaI5ItlMZzkX2FcJS44ytqhz9C1lLy9Mq5JwdqYYTIR+
	qaHwZWHEwT2Hbewxr6JXgHPN/E/SJSt7/1Ic96WsDeGvbwUAltyAHqb5B5Suc4OqBDOi2k
	FJy8NU6gFuhUF/vjniAB/OKMZO96hfg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=knQd2Wwk;
	spf=pass (imf16.hostedemail.com: domain of 36WD8aQYKCPIafcXYlaiiafY.Wigfchor-ggepUWe.ila@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=36WD8aQYKCPIafcXYlaiiafY.Wigfchor-ggepUWe.ila@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488bd1ee9e7so6024325e9.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 02:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778147562; x=1778752362; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yWeMPigyvPYxl+60ohT4HGLws9GhFdbTgcN+wfrxMEw=;
        b=knQd2WwkP3kyXmB1PtCEJPO5Bsvl6apazUCl0Bg2K4QbCsVtlXv1Mw1OdOj6BFAvzF
         RdJAyQGB71dptuCqRPx9oOh9xXeFoGDCFtCKqTs555wFJVq45I9j6mcur+8gxpO5HO1a
         a9YpNtx572W0C4yLJfdpKv2Gjendi5eRSUZn6XMfeaz3J47Jy8O0GOP5apzga8Xip3Rn
         vgCdvW6rs01geydQfrdlupgAij/eI+K6XIbiWFPABP46LQjvc0wBdWB5WP1YpPprkjAe
         cw1M6z7FhU/45LvhLNE8fYWi3xadjwSNwnRyZabRNx9eT9iVs8M32v2vfDJRS9AhrY51
         +UTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778147562; x=1778752362;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yWeMPigyvPYxl+60ohT4HGLws9GhFdbTgcN+wfrxMEw=;
        b=nOB0ZvPbWXJCtZfhJhNTuaVXQp+alcvse9eTk5uofP8FEGIEd3dQrk9Ogrb3foxJpJ
         NHORBWYVWVP5+5YKIA5HqwelSh5UMtHm0ygZWGuLV3Vtex1Qvdl7q/IRldglO14SMYfp
         h89AHm3KqbGYHgTZQQB7vdiFPil92DJcWuH16bmtO+sW1AjTSzjGIJbcInAkaknuPHnu
         PGCZFmcpyVawCyl4Gj22jUHxzXGs3/EUxbkWTybHMXCoAkTW1wKTnnk0xFLUVSA0i9Qe
         hRKtfbpXEVDM7LHnhwZXWBXvSPzSUOZZY+vXJFteerJ22GgdOMppo4CGGvupBt2EOd1D
         W0pA==
X-Forwarded-Encrypted: i=1; AFNElJ9mAkL1F2TeqVhJuueEKOHccxpbOD0seP32MTvk5Y09xxec5BI6BGzON5iXxjn1jp6bRuX59LJ9+w==@kvack.org
X-Gm-Message-State: AOJu0Yy9kca5ExDPCn3VyapKiAHe/AFHl4sHqM9dqq2zvgB6muunzjR0
	5++XA7H81HUyTsxOnSFoQhwA3IAGVLybVWBXto45E3+me/e9iZrndT3ixEELC5Zful2jqpdttHQ
	6AaXXUw==
X-Received: from wmba12.prod.google.com ([2002:a05:600c:6dcc:b0:486:f89b:7f29])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b17:b0:489:5022:39a4
 with SMTP id 5b1f17b1804b1-48e51e20705mr107659835e9.9.1778147561704; Thu, 07
 May 2026 02:52:41 -0700 (PDT)
Date: Thu,  7 May 2026 11:52:37 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260507095237.741017-1-glider@google.com>
Subject: [PATCH v1] kfence: fix KASAN HW tags bypass via runtime
 sample_interval change
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, pimyn@google.com, 
	Marco Elver <elver@google.com>, Greg Thelen <gthelen@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B375A18000A
X-Rspam-User: 
X-Stat-Signature: g4wfq3rm1dcmxdwkdskmozuxk7jkm1ty
X-HE-Tag: 1778147563-457841
X-HE-Meta: U2FsdGVkX1+eoAGQD7zQanyhmqGzcoeawa/8k4CdII+nxrsWIx5DE+OJeWLZt1hR26M+A104Vx9kXSwOnZktXuylIjHTXLrRLfk8MByia+SbOY8UH/kZOOdk7eAh9uL0UwnGxCCdv2cd3OWWn06VtEGTx+MAszJKcTQmudBoIPInI6SubX/eQmDxyRA7q/faXRypUj9Zi8VpznUY94cfA85L4RZZI7FS1MLe/0xERPOQQ20H+phTfKxnpo8jxFtubvW12cof7gKOsVpRmWEb0mm60oa1XvbOYLL3kn7nSbFpzsoo6nRPSrdyTVYu1NnSfnoftgQYnZUINiq2Oyk8TNLQ6bYBxJeMbXDlbnZ2z3GtNPM0oOlV5uVgOt4x8KdFvGzCFWAChU/PZX6oM7nZh4/pj1Sk5KXQYEWWrMTkWAKxXSSB09+SYDyKUlOSmrgkzfDaw/j0fFE+W3ekbnNeXQgWYRv/rMwzlb6aPBWZUaVhOocLzaXwIxllBwb77KgXGb9jSNKKyIaax4BoILLJzWm0A2MZKYnXYDF1ozYGcjuHLutAzAHWOh2DgBKJZ8o6/tmZ2Kwi6QB9jSYSz19RmqQLt+z/sYfyFf87btu1hw6zElfyjCTdj6WCrAS9yER6SydxS5Qx81N3PEtUJMiSYJCavR7hHq0ob9Jm0MMvsQ0KZy822Hnm7qQcWCbNfzwGKIPwR1AQba+cR9cM6JwqumcGgNGJUjjKvN8ZDV3ZodyqAtcFd/jjj4M9dBCfnxBsR27mSz54nxUoM5Z+UuBQBUQqCLle6AWfwmuO/c11gEOE744PSSreJqvxU2UsRFk0KuBeWLHPiwIZUC+TIWhVHcVneYA+kV7RgzJORUkppbebCl5gMaz1PciBonfoHJd3F98KQmgnBF8hQvYmRTe8T8IHWeTZN4J9W/Ssv5VJguLQ/KQm+3Si3dAESMQBMS59O4vr/qgZY11dqh/HBFQ
 20AtFKjQ
 C5Y6VijmOTbtLs2WSQkkJmChWbgYqNMnx1BSv7jKancP5ioH3RCBxEfgWY/r1jV6PRM3KzXwIDhjq1Wc8+dbhxiPj7Qt0oQjzCciVGhTSZAi8YOQYd72r7/NUDeHWv31svb08k0R+pnUoBOvTpNN55jgcBde1/BCKMf0bmfXOC1tLbB3QZji+sWSq3cnvIukc9F8TS9QqFggBuAHBXSns19poDViKiZRerAj5oF8ndPjmJMTEHDSztm3LnQRGAYN1dGI2gAiCW5JadhkjEKR6ZgQTgMnNpjPhOUnwCT0V9vHa6qn1au9Vld0KA4ttxQ6csIRwIEthdfFlokRJj59Lxo/DlYSuJE35eLTXTPWekN+1t8ao78gl2eOegSgy62/Ss6YUv8WBZb5g5w6YBkLIsWoYBiL+s0yi9ztn/3RxYXmrFVa3PswCNUyzK5qSUGwEXMNpygjYAFdeZWjEiBwGOI93Mmk2m/+TrUKRxfmoLEhQCbek1PIsX/bvIPoPwLCUZAfhcdcHF9z9O25cB/tzC8+rReejAgo3e0ir7NMmU1RARedoQLs2vqEudxkgawvbJvdYUcVx3kMGe007gf7RjSNROCmQ+rYIMT/kPy2owYesObcWzqnu7hRTvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a user writes a non-zero value to the sample_interval module parameter
at runtime, the missing KASAN HW tags check in the late init path allows
KFENCE to be enabled alongside KASAN HW tags, bypassing the boot
restriction.
This patch adds the missing check to param_set_sample_interval() to reject
the parameter change if KASAN HW tags are enabled.

Fixes: 09833d99db36 ("mm/kfence: disable KFENCE upon KASAN HW tags enablement")
Cc: Marco Elver <elver@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Alexander Potapenko <glider@google.com>
---
 mm/kfence/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 655dc5ce3240..ee6ae01de5ae 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -77,6 +77,11 @@ static int param_set_sample_interval(const char *val, const struct kernel_param
 		WRITE_ONCE(kfence_enabled, false);
 	}
 
+	if (num && kasan_hw_tags_enabled()) {
+		pr_info("disabled as KASAN HW tags are enabled\n");
+		return -EINVAL;
+	}
+
 	*((unsigned long *)kp->arg) = num;
 
 	if (num && !READ_ONCE(kfence_enabled) && system_state != SYSTEM_BOOTING)
-- 
2.54.0.545.g6539524ca2-goog


