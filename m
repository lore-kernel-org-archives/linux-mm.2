Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238F3CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE328E001A; Mon, 10 Nov 2025 11:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EED8E0003; Mon, 10 Nov 2025 11:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5575A8E001A; Mon, 10 Nov 2025 11:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 454A88E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:08:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA63D1401A6
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:31 +0000 (UTC)
X-FDA: 84095180022.20.26165C9
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id E94FC14000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TQV3oqcg;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762790910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wOEhLtmqwJvQkcukCJBLDCsQYr40AyxUB4yW9Ul+8kE=;
	b=nxkY+HJMNoDlvdYXLTDIEc4hLVYiq2dqyhiMCnAbk9PnR3rgbzmGpskKgh17CtlgIljZFi
	5kiH+Jcie/osliaIgk4gfwfOBVvQfVZKy1LgMBcQnaEL1md1qPbMTZdcLCLH7LR+bkIXZP
	S1ITg6oKJtwnEdBCHQhSGkcjoaVkb/M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TQV3oqcg;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762790910; a=rsa-sha256;
	cv=none;
	b=xJgPz9ZKcMWMH4+BVUrUTNp8dtHpwgaPZbdIwk1Vf0HZpegJHSh2j6MbxehJfg3iaku3me
	ls54i01pK6KrSpeI8Yzpx7GB2r+31ZojmqoMXmoShGUVKTT6oEtxngBBibTxRYo+qOpTwl
	lndakVjOEeJ881H8MyFM0TCnZq/hGps=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-340bb1cb9ddso2457450a91.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762790909; x=1763395709; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wOEhLtmqwJvQkcukCJBLDCsQYr40AyxUB4yW9Ul+8kE=;
        b=TQV3oqcgKejc5ZQjzYezpVDXO6ilTGzyKpFpUpQov9fCkX2hl2Z0kZZ+pNKxmjOtt2
         tnV7Qugv8j+n7IXg5YiBizbSjDkvlnrCJg3fWlxpExiNAKCK8fBTZ/Mhq3U30eC8gLfM
         qZKx3Yv93j9AKI1RPK0SNHJWauVYLSJRAl9B3GCSxou2YKsrZ7Zrsuk6BeiDANuNNIGF
         1Afl8ycB29/IbWVwywVORGpD6YFLmRWwve+beugZTxjpRIv+egja9qUSpYDkj1a6RAMu
         7MTvXto5cEX0ValTYkQ5sTCexqukH8DWTMy9AEMQcScm1OOdTtnlmWHz1zBtIXsExDFA
         wt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762790909; x=1763395709;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wOEhLtmqwJvQkcukCJBLDCsQYr40AyxUB4yW9Ul+8kE=;
        b=I54XK2Y7q8JchiAiIjb491nTH5oc44MY/rpjIYfGNzCWCOBZJ6xHoWOd7LMTMkxSJ6
         KGJKvysB3uqKFpJWf7HwB4gb6EUhIQ2fnzznwpG2vS3lcJbDMQLz9fEaN7aAVmkfhDo9
         Z4cm6onvNfubfQXGc4q12lBIohkhpCDkx3uBAAznAZdphyylbBA7tzJ7bIUtZ7UI3gWv
         qBjY3z7v0iGENyfa0B+U2yHYtvn+jh7/Uzigw/2KBHpK+TQGYija/HttwVJ+AeQb2vFJ
         fr3Ddo4Ccci8VJrTNUXPWJr/oXNZm59F59rKo9stBWoW9tw6Os2YGVZmwkAM0CcfljZ/
         IRJg==
X-Forwarded-Encrypted: i=1; AJvYcCWYRwrg1rqFwI9KoAP1iahfSlo44ntY5AsY7oR1xUOnQgPBxQmF7bk6ojsxCiBhJWQ0S7ubhQcZqg==@kvack.org
X-Gm-Message-State: AOJu0YxY1+v0gjQfOMSY8L8Ke22e+/beOC/PUfFPBxYq3vJ0l+Oieori
	UkhOFTpr7KRQC5PzGO1fY64X6MlpxQr6H5QsUMTb40Z+N0McO3O2QRIC
X-Gm-Gg: ASbGncuXmUSxVDYAcqmhHMveIW9I4kMjRo8KDUMcZku2XFNgVb5mi0gKCu3cOnFMSWq
	EEhuodU+15YtU87TtirjuWVGZeZK6WuLW028H+QwaWUig09CTzfUhyTD4VWZ5wDMWC7eH7op6J3
	hDddnnlNJD8144z+7vo4hloYalgpxzo29dtCNVCty69S4Q2FwQWPOLjYkKU2uplsFCfP+NfursF
	W5E2kJ+K7/LP7O2tnVXYB+Ye2HL1E+KkniuJO/IJhONuoUcYh5I2bfAhYJSChTXuVPP4odnF1f6
	WshFQgFBEl13KK6VKXGYsmNf597krFzjvrrKVEki+eqCGWn/tCDXn/DqGGYNxS4MjZtb0HnLZ7X
	M3mP0oEUXWaEEOakCvQ0l4KneOGWR1PnkpdclDfzXH5xHVVsw81bR4Vl2JWhQ5W67a1YJAbIu3w
	eyvvBR5aNEE4zOtEBcgkbigDhd/uSR3J2r
X-Google-Smtp-Source: AGHT+IGbpvlwu0mFvO4GmuLGLk5VScWwk4yNl8IlzCTRJTodqydRninvxxmlMasYD57cf8OIMXGSCw==
X-Received: by 2002:a17:90b:2d48:b0:340:bc90:d9ad with SMTP id 98e67ed59e1d1-3436cb91d4cmr10482991a91.10.1762790908614;
        Mon, 10 Nov 2025 08:08:28 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-34362f1f231sm9308893a91.10.2025.11.10.08.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:08:28 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 0/4] make vmalloc gfp flags usage more apparent
Date: Mon, 10 Nov 2025 08:04:53 -0800
Message-ID: <20251110160457.61791-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E94FC14000F
X-Stat-Signature: xpfa9ng17xknsameq7korxusegz6icfy
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762790909-895126
X-HE-Meta: U2FsdGVkX1/1X6EHostHqd5KnVAMedj2/tUdP2QvxfJ6CnpC69dLFpN34C729McZGR0Q9wk9yV/AUdHRE6cNRJGXa32KrQUMSyLX3teHEE+3A9lVx3DmZL6qTu3wJCzFfd9y6rv77rmLbCYaX5p9OsrCKdaiiZFkg+x71pr4NT32UNqDZOwu3PON5zJU5iEnD5Ua1zr1DnZMycO73W3La1OdxGk933NRgTEWv681FY+y+6qRO5u+B7F0+WSA0FKiS4FpA6Fd+nHnPDRuwXQ8YoZt5G70wg7Lvxsj/JNpxjZA0rszGhB99UEnN2o2fMicRnpt0S4VoAcdbxFx29hCwBTOTbEkVwwIvye/Yf6sx1AnSE/3egK6ULeFoqtO+mtH68kfBy0ltAI/wVPUKuHawTxcHMv6OFGbiPB0BKGjI3qpRAxOnq+/amxouGNhzgp2t2YKZ02nWYm4VOa8PY/Q/FgD945nO1B6aLwGg/mXyLALidL556C5jkblF+JeIVu0ojFrNFK0TcN/3WbKL58H2P2g6F7Emm070TIlp1GLhGWkELxno8vgBG9M6Del82R9ncEzVIpO1Z3AV65QZIIbqQBjRA85SMeMRZZeiLdlOlgK/L7TwkmVrMPWxu+w8i/XvqCWeMgdvRcYvm4Q3maEXZjZwQd8hdjiSuEtS8VbpV3PyJCcgBqwh305Oqn7oYnClytNjdXJycwKp+IbuQvioq0kPoL1nMA+doXZpVA54mfggY4qZxfNIz5jX56DQJECc9qH6X+G+LDDvIO6OtRMzZ29Zfgg/VFOq+6N/nPsHpXEE2w9YBJqH8EtYrfgcuFHCssvYE+OnkJvsaLycZLCKgIlmxE8B4ESo79bwnYbEoJPLjopUkyprh3phJGtGhQcGfMn6BxZ0aPQVbwWPlmHaoN2/YNLwvkekhOTcsHj7FkPZScxa8Ro35x3gNNdMbwQLz8/CbiuN21BM4pznHs
 wbkiPBJe
 NdKPZqH2473Q0YpRA4Ab5Vr1LUOEfkW9CrtF4PMK5+wpth5oTEwwFtR0YgDESH7MnVDV3/wSeKkO+OlYTDcV30VLFqjBsi5+oVObzLYdSXlvbJf9feHiZI7Njx69La/h8K0WrDvc8UtX9EADLTnOewktiMlVsZmzyULZ6opzKv0hwKmd4SJcRIQFceymsZQx5WzwSpFhOzbeTJ2f7CB2Hmw2sT/5hdGWMA80hcm7Gu+KsZiqDqF4E3eRMpBSCXXCdqKTXsNGme3CpKGcjHef6lc5TQJfw0tbkm1/t68sjH7m18zxrCziAB4M36ljP4eyCUpUQK9VdIkDtW7vImFi7rM2piJHiX6KGdOAP+gY2HaRzTjT/la0cG7k4d1nymojdGJeZWDVrDmpaCYMm2dwZV2ynuGl4DcdWydnJoBMcj8fpbgEuvRsY+3qaW4dYgUlk7V6JVny7z/GyIG3vp6pNooZmO8tarwNfZJ/Z8bxrf2pPSYHRSHyzB/KUOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We should do a better job at enforcing gfp flags for vmalloc. Right now, we
have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
supported flags. If a caller were to pass in an unsupported flag, we may
BUG, silently clear it, or completely ignore it.

If we are more proactive about enforcing gfp flags, we can making sure
callers know when they may be asking for unsupported behavior.

This patchset lets vmalloc control the incoming gfp flags, and cleans up
some hard to read gfp code.

---
Based on currnet mm-new. Linked rfc [1] and rfc v2[2] for convenience.

Changes from last rfc:
  - Collected review tags (Patches 1 & 4)
  - Add unlikely keyword to help the compiler
  - Replace pr_warn() with WARN(1)

RFC v2:
  - Whitelist supported gfp flags instead of blacklisting the unsupported
  - Move the flags check up to the only exported functions that accept
    flags:
	__vmalloc_noprof() and vmalloc_huge_node_prof()

[1] https://lore.kernel.org/linux-mm/20251030164330.44995-1-vishal.moola@gmail.com/
[2] https://lore.kernel.org/linux-mm/20251103190429.104747-1-vishal.moola@gmail.com/

Vishal Moola (Oracle) (4):
  mm/vmalloc: warn on invalid vmalloc gfp flags
  mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
  mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
  mm/vmalloc: cleanup gfp flag use in new_vmap_block()

 mm/vmalloc.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

-- 
2.51.1


