Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB4CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4396B008C; Fri, 10 Jul 2026 08:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BAA6B0092; Fri, 10 Jul 2026 08:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB18E6B0093; Fri, 10 Jul 2026 08:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA98C6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:41:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42DEC1202CC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:41:32 +0000 (UTC)
X-FDA: 84972828024.06.15033E8
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8A5654000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:41:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=di7dHDRJ;
	spf=pass (imf07.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783687290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Qh35ncbUpNA4+mhGWibuiDy9xo4hCCkUHZRzz0g7QTM=;
	b=eeSpV2YU6Rxkf7o37aB4WMZqkWN9JrWAX9il65bHIIgzW4dAMCNqQHFnY6/9oulbjGkW0o
	FAhRDmcXj8XQuqZ9LFTgJB2gzQbrjyJtbFEG52K7FvlLn0hsbUN4YLCIra7xeMPt2g9jRI
	8oIi0QUXK9pQJkayt9ke1JS67O8z8W8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783687290;
	b=xLA2uho+zAJinDPMZbS+DKxgV2m0fBUPbD8q1q0wBeASXuu25gUTViGUCALrZiuEWbiEl1
	c7NR4GtDmelk5yR+P8v2WMlUSTXDFp1dO+S/wZtdW7KFMGR8x4v24/Umkgit3cngcRfpbQ
	mEE81UCkENvOBfdnx+6ZC/9m7tz8T/g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=di7dHDRJ;
	spf=pass (imf07.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493b7612475so7198215e9.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783687289; x=1784292089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qh35ncbUpNA4+mhGWibuiDy9xo4hCCkUHZRzz0g7QTM=;
        b=di7dHDRJ/aCGGbXe/tkImpDiafe1neXSMTMcPJ1qEAKpIeJ181tdDmpiDaNOYlRUiu
         kD+7nZM9xYR6c82o4qpy8ewnNSdEoYEBl7B1a2CQqPYkfjovvMl7uvLPutMeNQV7zIv0
         lhlt4o3PGYnUFTgjHPZbxUypN13cy7H5nU1SyFezv1FGknheC1LoejiyrBD/xopu4PdW
         7jgUe4UbvY2BVe9oFvCw3Szst2Ayg+mBMyI+SCa3scJLk/VCDZ3XQCCWL0Cvb5tUKch+
         wYYfqwqGrFza3m9ENPTAd6C0N129eJC20GzoxuP6V26877lAABpoespe0PNEq1D0gEb1
         SY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783687289; x=1784292089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qh35ncbUpNA4+mhGWibuiDy9xo4hCCkUHZRzz0g7QTM=;
        b=PqkXCN2sCmcs9B1oHwVmGaNIK57R5lAoyYums+XA1kzn5TgI9hCLU9WogmEUHsbiG+
         bZDWw846QmjVf6nHehZZJDa5eAEKyhR3Vt4sYyvdLBg1wYmelkFHMjU8ROywpqBexIY/
         z0CMvJVX7ERmeUtXQteuGKFr8Y3RD+qqoOeJypPCSk+2rCRpr1Ru1gsSte69HfQpO3mH
         kJWX+YiNy5XTSdmd80ojf2htI/PXQz3ZvCkV4fH6TqS6ZDgShJUsCS+Hqp4L0zO8Lp3W
         qxEA0Puj2avvoDO8MENw7C47OMFsM5DH39t4r0wGTUS/9TpCFsiEJ1SoEh48bl+y06Ae
         mSHg==
X-Forwarded-Encrypted: i=1; AHgh+RoDyFHxaxdi4nVtQvAh//pA1sSRLvSkpgzzvdaJE0hHEfuVD0HVUonWv/g/ERNnJqjHsdkQDrufFg==@kvack.org
X-Gm-Message-State: AOJu0YysLfXv8j1EE+nSm8xhZn6iWsO8dRxlM8LanGTfJbP5VeXmx5yQ
	4CwJXr5YaEOrw2i5iso467qrnGLuX3OYuT6SMwrMAc8jm5F9AHDY/M9c
X-Gm-Gg: AfdE7cnK76Bm9kojbdmprKYEE6zvnTYz5QlepGeweKW0xydqrTjj2lbhlyyYwC7eqEw
	kuSNTiOToqunQHhsp8Szwkn8PXl5EQVballa8oI1j09Ut8wZYB5O4ET8WJ1niLC54LvvEDNHRS/
	NAtr/D6IHwgA69/Ry8R2RvhaQmoUzaYEjLCqSICPIVrDWCyMD1OqRDOfHDU/w5O6SC7xBtwpVH3
	/2TzWGVp5PJ5AbfPAjQFrHGjF+m87QE3omrYJL03n45nE7vGG8UWNaS8iL1LEv4H7xMvqewOzKo
	DHk7eAMfscQ4UJ62xpeesPHkWWcPRUonFhy3JaCuEBJQYnjJwm40Y4L4hiH/fkGpCQOaF9ed7zn
	/arHoge2QrcG9BO01iYt5VLlAie04dt7HhGQJi5KF1I/oXJKmRFbQg09NKSTfXa5pYCd6GkbCVW
	rDqoZ2w45mxgY1k3Nm3XWZAfOYxk6oc6mnLIiqmwPVjcC8Kr4ruMBA3yZyZM0u0hMNKkwbCYk0u
	SVfsI9i7+dWeCfCdJZAVzmo8m6rrBi/j8A9I0Vg+6CFXGO/Sknmm5q0
X-Received: by 2002:a05:600c:8b8c:b0:493:f744:e7d5 with SMTP id 5b1f17b1804b1-493f744e876mr5373875e9.38.1783687288603;
        Fri, 10 Jul 2026 05:41:28 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-114-138-110.95.114.pool.telefonica.de. [95.114.138.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb73ae14sm133079545e9.11.2026.07.10.05.41.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 10 Jul 2026 05:41:28 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH] fork: Honor task_struct's declared alignment
Date: Fri, 10 Jul 2026 14:39:57 +0200
Message-Id: <20260710123957.31774-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A5654000B
X-Stat-Signature: ewyshxfxup67t9hm4bg6smx796qo8mo3
X-HE-Tag: 1783687290-448793
X-HE-Meta: U2FsdGVkX1/qa0EJWsUTASNhf4FR5Z7CNXiOCk3tND/uFrnl4+XWQI2RUh1CHT2njKYxz0Lexyzaggb+PqrntLQmmiYcDGKJ0tD/z6EdSZynqmoHkDRfdulu7I9yFGZ0D2J2DKuiffaTAaNyv4PtSwm+/ToOCD/nk8wjPsVK/hXRxYQJwNw1RTDdugGF8MMCKMiaBfxy6ffZAKXQwfCOcxilDT3nKkIFECjs73YrtJUzZgNSTJtuTqdjuIoDfnKvdQygv9YfhqdNtt+QnTqzOHcm6ce3vIEVjny79FDAerlzir2mFjERxWXRRXLG782Gk5KuGfx4jODIWOtEiOumN4P6ca7tOvBLqdGdyXwX3fowdSNyiqK7qsxRktMWmgOksIhMMBR03puccPoiPhxEv7aPCeMwYAKi4UHU3BRah4nwi6kAMGyU0UZqVZwMt318f31DlAwGa8DIRpHvhPJqOmkH01vLJPtEjigw8amF1xz5g4RNyAP8v6XQxZW22QQ55E//fdbz6xYMoo4WTKx1uIvd/nsuUXWCuSpwvKQcHFw9bq7dkLvYm1dc5rvHZUvae6h01pp9aKgn/TrBqvz7qSpQ31Bh/ONHvwdknoIR1KALXR/w5KCcPlpQ476ldZhV9LDik4p7M1QlZRGJyyImMT03sO16FCkmiO8FcBeEI8RgVPDq+xZ39MMxCZjt+LdTyF2INLqJspxZDNVMQ/FcVXM1LnWYQRWlVfkGIwR19+ZVNCg/s5I1dk/qa9BwaNU9/tMg28s+YH81pLBUJcUB82U3ZM6sX/Oy9CmRnxHZg6lhro9vgEmZd7muUdxVBBZ3cIoo9L5zfxVMZ17pPYvjj/TDHrkYPvno5KWVfSdI4MAuZ2Baked7uWjy/Vy6Szng/sGiuiIBpy58Qo/q1GMGWDal5Wwl/hJHEVQ0XqCqDrZxwYGTKncDazrSbNiU3r7WkJpnlxp+DdIibLo3y7a
 gAxRnJ6n
 McWIiXCkU9tE7MA7/NnH/WvwgmXlr8y3Q16fYbTzOhg7xHLIbVjy4NI3RjZs/xf3d0oNL1GaCt9jNjXziq1wAUDq9zWAyLeY+uy+MJMXhl2RQ4IvttyLL0GdzU5IC4AOeB2tfCiI5Hgsihz+lpofOQSTaItrKv8l176iU258MJ+TaLqN/CUnXm4elfc5iyK/a3LgSOCOd1paYVtiODjOrFsXAeyT5pu6voNVLiNpNzCUAlmh6VzxJMeizYGcwifwQZbDpuNgbelHO2YLHBjH6bEPGvW3EAaBWVzy/j0JScJiimNPWvRiVR1M3UyARFghnWGXvJoY9POnzVLfdcFlyWhvHMBKSnDYjQXBOZUJTDXRF29vamA2qYhQix/PUw3wbWaSaXYtFmrBuxLWuzk3g/sU5qfCGxeYuOutKybVJDpAsVyP1199fdYa1mzPtKSCZD2zTmcJrFR75ppU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant
size"), struct task_struct is declared __attribute__((aligned(64))) on
all architectures.

But fork_init() still sets the task_struct slab cache's alignment to

	align = max(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN)

which is smaller than 64 on architectures whose cache lines are below
64 bytes: e.g. 32 on ARMv5.

In practice plain SLUB happens to hand out 64-byte-aligned objects
anyway. With CONFIG_SLUB_DEBUG_ON the red-zone padding shifts objects
to the requested alignment.

With CONFIG_UBSAN_ALIGNMENT=y a boot on QEMU versatilepb (ARM926EJ-S,
v7.2-rc2, gcc 13.3) floods the console with reports like:

  UBSAN: misaligned-access in include/linux/sched.h:2087:9
  member access within misaligned address c295d7e0 for type 'struct task_struct'
  which requires 64 byte alignment
  CPU: 0 UID: 0 PID: 15 Comm: pr/ttyAMA-1 Not tainted 7.2.0-rc2 #1 VOLUNTARY

Set the slab alignment to at least the type's declared alignment.

Fixes: cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant size")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 kernel/fork.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f0e2e131a9a5..b85cf1343329 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -857,7 +857,8 @@ void __init fork_init(void)
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	0
 #endif
-	int align = max_t(int, L1_CACHE_BYTES, ARCH_MIN_TASKALIGN);
+	int align = max3(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN,
+			 __alignof__(struct task_struct));
 	unsigned long useroffset, usersize;
 
 	/* create a slab on which task_structs can be allocated */
-- 
2.39.5 (Apple Git-154)


