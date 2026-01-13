Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F25D25031
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288E76B0005; Tue, 13 Jan 2026 10:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F676B0089; Tue, 13 Jan 2026 10:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C196B008A; Tue, 13 Jan 2026 10:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01AF66B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:07:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A97FB1601AD
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:07:23 +0000 (UTC)
X-FDA: 84327269166.26.66C1DAB
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id D604F80007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:07:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YYVgw/kE";
	spf=pass (imf02.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768316841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DQnWPRxNH9q72zgZ6FoCl23Dsj1j6a70O0K1DDg0+mo=;
	b=RwZLemcBHzKAQOLA6nPWzOszgK1ida7LYUCsHAlZOmfIu+/43SeP35ed2QrBpTOlwdIJei
	VxcMfwxuJZB+BijXbUGQXP6yCyfItiucSBQkuIyeRpoNt/SHrX2hDOXMKa4i7z3JcDqLf3
	y3N1AsWDNj/I1gKo7/xfzKmHzb68cgo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768316841; a=rsa-sha256;
	cv=none;
	b=gyOFM/bXyjVeVYvDW2hqwDmpSd+Bf8JTWjCt83ByPGjjhi6yHm4MF2EBB1xEYS+aGZAQyX
	cr1kzGEkBfEWDtEeCDgwKOMZsN1wG84gOLZgvdVVV8nOMQTxLh3Kun+EWZbEnBp19TXmBn
	nlrH2OuegjBnNkNXXiNgTdCx1jtjprM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YYVgw/kE";
	spf=pass (imf02.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34c213f7690so5102066a91.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768316841; x=1768921641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DQnWPRxNH9q72zgZ6FoCl23Dsj1j6a70O0K1DDg0+mo=;
        b=YYVgw/kE2Uu005sOvFbtksRCtfwXar86Fv/ZXS9eGRFnlI5zNDejcFPaAih37JHyiA
         jCPiuNekUWZuz+As79vh+Hpmo+hWwmctx9EC4CF2FKPLmB1gTovPmYtfOGYTinNGEbnl
         Oo2sYp9tEjRl7b/uT1AGyXVWawE7+aAnbwZITUjwrydrJHJOoNi+vR+6pZZ5upTKel8u
         34xHWw+WrhcjnF1ZNF10i7ZyA90UNRE87kS3dB+jk/3SgV8GTIs1ch8JiCkR0f88bWm9
         vUYWklNaI1O9kIElBtTAd0JLyVyZ9s6V2iDaFQkWRJyAg4WMVbvThCp18xQL1wbxGAo5
         mRDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768316841; x=1768921641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQnWPRxNH9q72zgZ6FoCl23Dsj1j6a70O0K1DDg0+mo=;
        b=dcyncqZVkKW3xoW6I8Z8y9fSbaSQtKJJOyUyR9/oMJ/anMGhQ+4kSdDU5wk+GHWD90
         ETUGYClzyzgquKiiyvBz0J66va/vh+0Iwb0fXmakkKZc+jtSqrpXymzAmbGiR2CH8PGS
         uSEunK6NzV1bkQdUBiLRO3lH09srebuG4fRDVeBxE1FGYccrvHmfOySeHTX/YhnNYi0O
         qNwAR0I7h4gYu8jPr1abIXPxcVPybVEFLvtMuhMqTmNbAu6SaONDIs82pdU1egoOLJDS
         tBT/OWsUWjs8waLCT88YCxxnUCkWXgkxGAfs9zprvGFAz4193n/eSj1r1OJ32lfjugLq
         kr3w==
X-Forwarded-Encrypted: i=1; AJvYcCUyBtyQDWI8PD74YCtNxsiTvvPVnpLIf6AP38lLDRlt9zeD6l6cJylxRATdagbjFpzFknW3To0PSg==@kvack.org
X-Gm-Message-State: AOJu0YxNCD4IG8RwTMhOQsgjGd719y8ZLuKtEl2gqOehD7ynoxSc9Bsu
	67qsH8xLkEDAuWHJ48yXbVmT/jTsiJej3VQgcYFJXVmuDSw33hcxIvoA
X-Gm-Gg: AY/fxX7osrGkR9BkQfkJlk13ZiV+WOlaYMYxlUxkb2qcbNx3xAXHzjvKoYu0s+1CVjL
	1xnGsveAGxKAGpoyFBuQcmvmdag0QTbXijFv4GiYerZ/Q61kn5u602T3Sbk6Jy7gE+Mvxp+9NnG
	qJaroeXYZTds2MkIejuIl3aHgISs3JSwTRxADnqlAzepi+/pcMfBitNz1gnP2tkx9I3yK0kXMox
	SNowFYkyQRuxQ9lPMWo2hRTkdQEp0UzPSDHCLmbn9WNo7Tfdibv3CLq83hDJeTOMkzUb9g5r4lE
	BPKZxbkgYS0ssu2TqX8wRml0UCDL/5QZz/wl4yS+l7jujTk4n64IEIDEME+WYuXCdDn7wgyzrl1
	KZz8fNfUgSakCLUYBb5vPbf22GON//uRThB9gR6czUpFTScQwEyt1Y3KPOqzKTG68gl6Xied6T4
	YhJK+qiDW/tN9g45ZsU8GmHbQTU1uY
X-Google-Smtp-Source: AGHT+IHKPSJ8kXxnj8Kql9+bODbOjeYJ8UeB1XiJVxthrhBSw85O6NRJi1luNAgVbTgInY27JkJcvw==
X-Received: by 2002:a17:90b:3c09:b0:34c:2db6:57f1 with SMTP id 98e67ed59e1d1-34f68c28425mr17392421a91.30.1768316840509;
        Tue, 13 Jan 2026 07:07:20 -0800 (PST)
Received: from LilGuy ([2409:40c2:1000:ae08:9f24:c96f:d20:3f76])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-34f5fb7419csm20596125a91.13.2026.01.13.07.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 07:07:20 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	linux-mm@kvack.org (open list:SLAB ALLOCATOR),
	linux-kernel@vger.kernel.org (open list),
	linux-rt-devel@lists.linux.dev (open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Subject: [PATCH v2] slab: fix kmalloc_nolock() context check for PREEMPT_RT
Date: Tue, 13 Jan 2026 20:36:39 +0530
Message-ID: <20260113150639.48407-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D604F80007
X-Rspam-User: 
X-Stat-Signature: 3k3ip8drojwo3kshqmwx9jkapp5egswc
X-HE-Tag: 1768316841-661267
X-HE-Meta: U2FsdGVkX1/0QPTvtU2JmAOcD3GG9vJyIMXSmHH+gZYPKAZT+HMHoM2hMFOMqkE0jfENp4tjdrqDEdO+7F2i+KPpgOBNq94qHp1waZm6eV5zq53f98QyL8pI7JDYriQYu+bNE0tkwXMjIR3YqVC6Q76Se4v2x+27sNuoVD53rYbbV9fCf9FSH2XlhB/83rBCH2eqLxUVB2qoNp9HPF5yMviWxP/PHh4qWoZquByzqkTsbw9k96b1ovU+Do/LGLvaRcKWcyg2dsob2YJynurtrFp25SaPfGmX/vHNjKK77utk95mrEfummO8ECn7mXiBy9nc8d+LzLx2K4F+CFjTJxUlLKZMICQkWve1njf6W/c8FslzwgpZLGbc0tkyBehbfy1GJIJDJysMRX1S+4pCQOdG4ySK38vFKWXXiwxTpfUEaxBdEtYGHr+ltN4POfpkdahtTsx+Dqnd0d8nwa56MurYzmv9KXOdTLrhpW7ugeum3c2awekVVgZCuMAgUTzwkThikXIrlMovBFTLGIfR8AiH4Iwq1vmQfJXXwxRwaUMR3DNu3tmHwxuwKpfq/sOl5oX/9D2fovPRDbdJyW0gJV8USl+mJAKs9089pCXY82V5OQXvn0xy54p7ir6e9JpkL3L9KXGLvA+s5A37n2mSj6Uc3b51yaYoGyp4r2dyHZcwbR69cAHEsR06g9ysV4dhSMJg4p+yIAPxIKngLT9y0/uLCQIbvFUZ6D0zr6JBVvZ6XpDyR1p3GP30/iYeR2jJTG0wCRQt0OXQq28/L3gJtIDst0YA9XxvLM2ItqmdTH+zs2qG+0WLJYAKZS1zl7qlc18xnXGkoCRRJ1ZBwbGwzgEy7pReQwSZduNm0kLZithEysLgrers5VLuLq8EKmGiheRFKvVB95erkCteZ5KT8t3cKBTAn8aXcKXKaO/drczdqGnWpEHuFVU8cI+tG35OgHrIUsKGBvAb6fedGupH
 FPYfFkdL
 WbYXVq2RMtakK2BHGFNhPfqdsXVR/UaoCn2uSGcsujYSNfNjwvuDKW9xkbMnBGf8Z6hLILFnLGzlQZjYywTw0Jp+8KlE0Whiq5Ab1DtgemJSwfHCdbZ9pxDcT15CQkr9USgzQKzQqNNFMuy5Nq1K1Q5Tjlp+kK+p65ijhJMvFo9wQ96h1maSEKjr0CPzXfDmWVOobftK11wC+3qLKmIBplQ4CPfR+oCsiU/uTydURCggn5+hvz6gY5mbxx2GXoIxgIr1t9kowU0Uify0dXvJi9pZWb82PfCM2k4tBvhlize2KOmX458oRac/ejodI5bK7BLCQB0wUebWlxbUot8L9v/Zowzl1LUgNCFyOe2h3pTfgwJJ8VgoNt4EzsAHTpmZkPZHgeNpvuiq+SOWjND6grL2CZ0DeoitNatTraMqWU9wFXfP0IEWxh6bB1LlH+IPbeRBVVUyfQ2jBvdGSYB3Qyi6I9FBqd/c65vQi8pein7EM+IdoKrrbxqKRFTplHfOD7x/3y0WfRIolo/8BXXMr66Sf28n1lT9LLDkZrUd5JN8Ts70tfiFhrIBTGYHB+eVigjh/YRqTSNGjvPlvF3QRLQNsWZqtGXannXfpii/L5UT8XNAQu9kMcs/pfNFodvyilJSFujPfsBKSbg1EqdkBdxVlNvJjDkKOkoPF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
context, but misses the case where preemption is disabled.

When a BPF program runs from a tracepoint with preemption disabled
(preempt_count > 0), kmalloc_nolock() proceeds to call
local_lock_irqsave() which attempts to acquire a sleeping lock,
triggering:

  BUG: sleeping function called from invalid context
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
  preempt_count: 2, expected: 0

Fix this by checking !preemptible() on PREEMPT_RT, which directly
expresses the constraint that we cannot take a sleeping lock when
preemption is disabled. This encompasses the previous checks for NMI
and hard IRQ contexts while also catching cases where preemption is
disabled.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
---
Changes in v2:
- Simplified condition from (in_nmi() || in_hardirq() || preempt_count())
  to !preemptible() as suggested by Luis Claudio R. Goncalves and agreed
  by Vlastimil Babka
- Updated comment to reflect the more descriptive check

Tested by building with syz config and running the syzbot
reproducer - kernel no longer crashes.

 mm/slub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2acce22590f8..642f4744d5c6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;

-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
-		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
+		/*
+		 * kmalloc_nolock() in PREEMPT_RT is not supported from
+		 * non-preemptible context because local_lock becomes a
+		 * sleeping lock on RT.
+		 */
 		return NULL;
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))

base-commit: 559e608c46553c107dbba19dae0854af7b219400
--
2.52.0


