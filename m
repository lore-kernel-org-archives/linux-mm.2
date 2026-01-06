Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6397ECEFD11
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45C76B008A; Tue,  6 Jan 2026 16:08:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3B16B0092; Tue,  6 Jan 2026 16:08:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5536B0093; Tue,  6 Jan 2026 16:08:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB3C6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:08:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2152F160C21
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:08:10 +0000 (UTC)
X-FDA: 84302776740.04.0799AE7
Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com [209.85.218.65])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2C0DBA000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:08:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=24giguF2
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767733688; a=rsa-sha256;
	cv=none;
	b=qmXuhsLgeNMm7EXDU7sY5o6VqfJktHBcXsuRWgjqLyYQDF6Ywtcf/ussYZCpfe9QBld96q
	2L5mapfrz0XEBAnHtP2xJXe7TJM6Umb2UtCgq57DybJASzM3oT+E23EDYe4RcmC2HVKhgi
	pgbUE3EQhAzAuXKYZOmJUDnhkHpxwvg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=24giguF2;
	dmarc=none;
	spf=none (imf15.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.218.65) smtp.mailfrom=boudewijn@delta-utec.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767733688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqqUNyuXR+Yvt4RTDI+UgqNMmHuV3qmM4zjaX+NQuDM=;
	b=PVHMwTrJfeo3ePCKDTR0Yy15D1e+yKYVH+LypjHkpWGwW+3r30S/ZTM4kuFKlmibtPPtCP
	TqIQ6/ZkW81LM/QQuIXmEsz0R6BkFVgpuIFZkJjESVD6mdSzF7e7ZpNFGpePZ4/sZctQHe
	+2QP9yN2njYZinMGn25OscEg12zj9uY=
Received: by mail-ej1-f65.google.com with SMTP id a640c23a62f3a-b7a02592efaso231032766b.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 13:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1767733686; x=1768338486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqqUNyuXR+Yvt4RTDI+UgqNMmHuV3qmM4zjaX+NQuDM=;
        b=24giguF25+uVz/zZExdGbejp7fqSxRSSQRPsPOS03RX+zKOJaUvNKRo7R5bnUDXF+W
         seYDUXFU3vb3wvh4Tcbg+9V0r78A8g0BRkfnyilTpJ/BxVkbyNlxoLlVd0A3YQqQpEn5
         tbU6Z3GMU7dWiybUz3e436y3xYRYjf2xbVnLu4tP5R8xwh8cx2Br1rtvM6UDpdmq7ktP
         IL2X8yc8aiwOyMvRp7qCBnjNktgmOq3zgSucHTwwcj7wiGRe4yMkNzZAjWqOMxQJyTCa
         69dfeqIMa89zUaEw0MqVsm2X3F3LQoYs4tQ1R4tKe1rQiywmX3iaT3vcH3DFzfg7hOqy
         /BWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767733686; x=1768338486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RqqUNyuXR+Yvt4RTDI+UgqNMmHuV3qmM4zjaX+NQuDM=;
        b=ZlyMgS7fN+t28gs+JIv4DXPakffNo7nuho9c2v7E3tjhDxjTh22Tlsgg5JCsDndrlU
         DGKEarPw3VUFdsb0XIl2iS/92x1KLDEuvpwoDa4MhvA5j1AJPTYDz26icN+g12MNBQvG
         ioRNgHmawGupCJlhoA5SPdEYayauuygZq7WP5Ns7i7xZhHXzW6+rKCIVzqqQt/P9JG5W
         2p2ACc2nW0TkhqVsGkOz7bgpHjUnQWoq1zfXDRWD8cMRne7+nvJgYZUU4QjAcnmtN6A6
         Nit/uplkwBBC1CHNdjL8PMriBS55GKyVtWS6p5aI2pYe/NyVqq8yBkV8tVYdv5s7TSSt
         T27w==
X-Forwarded-Encrypted: i=1; AJvYcCVx6AZzutnPnFnDhJdPKbZVKhJmXc5UantCLePRr7LaBqlcXYzAFhqrX6HBTa/arhWiEiQh2xBVCw==@kvack.org
X-Gm-Message-State: AOJu0YwWvt5B+fll69KUNVhSM0F2dBcKHRkReGrWdUfXGbyKjJqf2P6h
	xvM8jZbN+SWa2ND52mA5f0eOy0wcxvfEvV5nzdd7ntTjsBfllTyN0sz0EpLCYZKa3w==
X-Gm-Gg: AY/fxX7E3ArjLkZrksR1Ga0uuKZvyEr/VVaUl+5X4i9Ini2dY+eH6E7s9cvcQuE5/qP
	+GPHfzHebekainyWO0Ippps8ElSbVfEIYqjgqziE7jxiB+7v2kB7+tKRCWNk39Oauxu42GO8qvf
	mnP7w78GpqygfVhrRueFyWP4M6VH4QN99WGmf9il7BMjkV5UyRX9fu2nn4TtS2tyj2t0TkJewWz
	FRtkw7lWg8QQ0EH3t37I65flF3Hik+ms4HgGYsgkZai17saeuTrwza7qadiuwjWrTTwCmj0YCrH
	Zn0x03HHYJT8mIb32T1xiK9oncfGItyC9pcWd85yCdWKY5xPx3NaGOcYi9Et4Rt+3RfNaelZCwB
	/TWCos5Ii2zBxQviRxaJAjMAjs3Z6WzorAeLMoLSXs7+nm9qV75qVz9IMXid9Bfui9wJ7dqI6ih
	WGBNn0s9kXU1eWjdqKAE1ejje77y8qwlZ08zULvmRlS/zserTlKLsdslBhSPsLMdsilnrwcBCuU
	TM4yD0G4cenSGcsVJCTGL6wfmOq7p7fsIBOZmByotLGL2iw6x0=
X-Google-Smtp-Source: AGHT+IFUzgn3IMAbiaVWy1jakAZv6/wUacnrCtIooZwJJw+s/NPGplo36j3Vx+jccIDOiDOSIvcdMA==
X-Received: by 2002:a17:906:ef0c:b0:b76:d54b:849e with SMTP id a640c23a62f3a-b8444f4ab76mr46587066b.34.1767733686468;
        Tue, 06 Jan 2026 13:08:06 -0800 (PST)
Received: from localhost.localdomain (2001-1c00-3405-d100-fd78-186a-9428-6b97.cable.dynamic.v6.ziggo.nl. [2001:1c00:3405:d100:fd78:186a:9428:6b97])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b22c3absm3033836a12.0.2026.01.06.13.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 13:08:05 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: Liam.Howlett@oracle.com
Cc: boudewijn@delta-utec.com,
	akpm@linux-foundation.org,
	aliceryhl@google.com,
	andrewjballance@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: [PATCH v2] maple_tree: Add lockdep assertion in mas_dup_alloc()
Date: Tue,  6 Jan 2026 22:07:57 +0100
Message-ID: <20260106210757.465586-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260103165758.74094-1-boudewijn@delta-utec.com>
References: <20260103165758.74094-1-boudewijn@delta-utec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2C0DBA000D
X-Stat-Signature: q8czt34rrez1n8dww4uqadqy9emqukam
X-Rspam-User: 
X-HE-Tag: 1767733687-393337
X-HE-Meta: U2FsdGVkX19TXFTyGDrygdJSBguhMSKjXSlBi+DHxUpdx8rXOQV9xeRiQ3U3TyczLykPxB4U/AZt4AZN2r6UmxPhltPIlmL++1xkUnt+Fsw6aPMmxwcfcWyOVy02mwNDph40pu228fTfU1luUr7GnFB6n6ANYquLqj02btHrVHlMNHApYMcJZej5ntmT9zzS+G6bgawUHkY6e8+DgsG+izK1eROswnzT1TxAx9DIlCXqp5Ob39fi1M+POVq7eG/3eA1FXb/p7Qa95j23pJa6hOHZCgXKAiXNqwyvjOzs7NvD/8u0qnNDZpZLx3S3w2LAdUIRVLLo6RN0zpkCYeWQJfMpX65YnhmiecjFHe4SMOgB1ayag3jUH9gmyPyyE3NJUZBrh/HL3VZEP4elfWqdB7XJWFxWF3dqCyiZZ+9eQSD/CohnZOOrjJJZMXNlqEcoUGNyc6k3sh3d7evxP3R+cagbNkduLOwj6nG8elh2v+9VrYmzq8kTvGgDRek6j1s6sqggxGuQQZiHVno9FaUfnI7KvbunFU5xFJdumi9qW4x+lZhioKnI5ZEuDHwc90eENTwzS/6I9/DeSA3EQPY0Qu7xv5yRA9pREZHl657zfwUSxMUwzmAJy9kukhiPHC6gzSfyiMLiVWRPiw/kor5ntZjbwejnfcdpPB0YwRcnCH7V9fssPAaQjnTJHvDd43iplSdA/gShqsetyS7phapmjFL2PoFBJgQyMkdOjt3tamqgtgkY6B1iMKuhFVoE6pG90umtGFFVy61/saLyAOE8UTYUseWPTK19me/VGBO+s3elok6/VHL63TQHdUjLkezT9lZTU7kUdByzkj0mP90zQ70nd+nKW5D28EeXtHqVKywL/9cZVFZwqbxMEtyPC8HZWE+poBoXQh3EpSFkm+Z9X9KG2Px8WJHWKft7DIyITEUYtIVheEit5UC7gyE3YE/3IrKYJ8Dj+qRJ/47CPFj
 m8cX8u0u
 uwbblvTSl1gnyn0575kfBRn3k+blKs+b+BWOnnYSZ6xiBAl744XCvaswzhhKTr22+GuDwCBrrqn39m6d9IYSvWCBWaaBjdiCbY7v5UcWQCaBkBJXv8MEHRXeHXSEuk8nvvE/4OGzs2Wms7n42Jhm59P/qnyhwVHz8XIXZHNaDOfOwU+OIaavL7+BJOyiawM5/Q+vpckSd4NKaY4J838Lw+9aAHKZkc5bwJKxVtJaH7vthdyjekskLyz9os7KQMlFI4fLRbOfuFaT/mCX4GtLHXtpEXvnftdkpesJls1SADgX10rYHkVkExRpqkqnF1eKLixc5FgQH6pgdfUErIgBGuGo+w4k95iKbmDfgM2aZZ/6+gryDqsdRN+mMSU7Q8AyZNqkBQmmH7PixYU7fESV2vdwXm5yaXxCOMS4wwYRzOtCVIKR0KLD6ct2+KR8kIlwmx2rfIXg8KgM0C5uXU3AzIb/H2X8x0xFoMQK0ngAoOXAu9rCgrmRpdNg13wD1cf4b4UUi7nFhZIF7FiQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The __mt_dup() function requires callers to hold the appropriate write
lock when duplicating a maple tree. Without proper locking, concurrent
modifications during duplication could access invalid node slots.

Add a lockdep assertion to catch such API misuse during development.
This is API hardening rather than a bug fix - all in-tree callers
already follow the proper locking rules as documented above __mt_dup().

Signed-off-by: Boudewijn van der Heide <boudewijn@delta-utec.com>
---
Changes in v2:
    - Replaced runtime deadnode check with a lockdep assertion
v1:
    https://lore.kernel.org/lkml/20260103165758.74094-1-boudewijn@delta-utec.com/

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5aa4c9500018..3b4357f16352 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6248,6 +6248,8 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	void __rcu **new_slots;
 	unsigned long val;
 
+	lockdep_assert(mt_write_locked(mas->tree));
+
 	/* Allocate memory for child nodes. */
 	type = mte_node_type(mas->node);
 	new_slots = ma_slots(new_node, type);
--
2.47.3


