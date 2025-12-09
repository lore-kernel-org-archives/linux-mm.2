Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D15AD1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 05:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6344F6B0005; Tue,  9 Dec 2025 00:44:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4C56B0007; Tue,  9 Dec 2025 00:44:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2BD6B0008; Tue,  9 Dec 2025 00:44:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35CF36B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 00:44:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB50812F85
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 05:44:19 +0000 (UTC)
X-FDA: 84198842238.22.3B2DF4B
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E2A5140005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 05:44:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IKxEZNVn;
	spf=pass (imf26.hostedemail.com: domain of 3MLc3aQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3MLc3aQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765259058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aeRS0rrF2ORdDNQRDFOZx3EYhiwIbLZ/NuYorYmEULo=;
	b=Y3R8ceh4ydP8Yxg80j66VLtAdj2lZT5t4/fLVUgTd9+3SdM17UCE4ck5gUO60FE62Q9OqQ
	E3ip+oLSwJZCI603+oHoGg20n9QCqVYQxiFa7occ1dibn0lqEksaI4yaRcq8TuJcgH60+t
	wlphQaPaim7OUqtlypjMJTj4KkW8eyY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765259058; a=rsa-sha256;
	cv=none;
	b=8PgXlzJnpBfKB6pd7DOrXhIE2JV7x24A1Xddz8/4tHTSm/jmrs/QDunyIEYLZbzQIknKva
	+ub+SljLIdYIrFt36Ey6hlYMRiDY41W07dvmyV9GjtIi97m9qsPI3f7RJv68hutUCO+gon
	M5jl1Vr0r+nSBPWPvP9Fjalm+nRSpjc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IKxEZNVn;
	spf=pass (imf26.hostedemail.com: domain of 3MLc3aQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3MLc3aQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343daf0f488so5269471a91.1
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 21:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765259057; x=1765863857; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aeRS0rrF2ORdDNQRDFOZx3EYhiwIbLZ/NuYorYmEULo=;
        b=IKxEZNVnrD8undttNDmXQc/m9/UoWSY4mXTi18HqCvos1p0g+YIW87Cej8lU2meJB6
         yHVxExGSqMWsOvga6sLNPZQiNdtid6aTtet+EpZGWactaGqLIA2kZol+KLgpyw9yMpGI
         /P0z1m4fN0dkBpG6sklOj6PuA3J7EMqxaIs7kpgJ22CClLg8bzjuzg+lT8XLTD4u2f7l
         wVWD34FMJDskXG+F2GgqlPlXhSncN1vgVBvaxQkrT/scRksq73QRv9cnRKNtMRJ7AqqH
         PTEvXKpvQWQD9dtr8hQYveNeDIJoejtyfQBimcUDGHdGYgu4I5HlwsFFFl6p47P1EISd
         WezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765259057; x=1765863857;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aeRS0rrF2ORdDNQRDFOZx3EYhiwIbLZ/NuYorYmEULo=;
        b=evnN3NpPgCdInFgijFNMOEGiR22P1zEZDo0ZKJBDI75B8qaOv1g+dA4uXEVNtFoHte
         vLMHew44a//ZJGIsFIY8zKXVDTfvf4TzvTRQGvuSE5waY+GrHQXXXKV4Gwh8JfbIzrI8
         KdA2bvvKz7Nrs/NBsY2kf0QECVkMWxF29SoHC7ifntkhuTEvXeBFbboVBah3jXLOjyAn
         SwKFP2k/oLRFAsS2Q2hunqrgS4uTpNo84JpNZbxbN4+L3L27AMH6GeN5CqAr8GIpeRaJ
         4+SvMbnS4b+FzRsyTgFqtaY1f0PxA3RHeZD14lOncFcbAhsHygNxzK/w6dl1S8TEc7iI
         8kyw==
X-Forwarded-Encrypted: i=1; AJvYcCV/uh2qHtCC+w832oftBsPF724tYoR38dxrTPIyWuW1/Be1WULCmsENtZRGziG4uFC9n8I2qZ/Ujg==@kvack.org
X-Gm-Message-State: AOJu0YxNMF1EYt0Zhoo7EQDZ4bKBxx5UGtfkRXmZ6kbhNOoKrMjyEhaF
	zwo2EZTSEBuD/4XmTcT/D5Wh4m0lSOxz0sMRTnJcBrf9BHTasImXSGlex8U8eUbgANHdP4c2YS+
	cQNmUiuXsC9nAXw==
X-Google-Smtp-Source: AGHT+IH4X90kdSgY4gS6T2ygfWyabi8rSDiiqcDLF1Md3MDGtyvaNqc10OgaH/bpc5lD84VGSrNHO3O0B1jxUw==
X-Received: from pgac24.prod.google.com ([2002:a05:6a02:2958:b0:bd9:a349:94c7])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:e082:b0:252:2bfe:b65a with SMTP id adf61e73a8af0-36617e36e06mr9940237637.7.1765259056752;
 Mon, 08 Dec 2025 21:44:16 -0800 (PST)
Date: Tue, 09 Dec 2025 05:44:14 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAC23N2kC/4WNQQrDIBRErxL+uhYVQ5Kueo8Sitpf80Fj0CAtI
 XevTQ/Q3byBebNBxkSY4dJskLBQpjhXkKcG7KRnh4welUFy2QrJe2YUK0F7Hy0L5Kb1/stdq3Q
 3CFQoONTxkvBJr0N8GytPlNeY3sdPEd/2r7IIJtig9GBMj9bw/upidB7PNgYY933/AOsBhcq9A AAA
X-Change-Id: 20251208-b4-vmalloc-might_alloc-754a791e4e10
X-Mailer: b4 0.14.2
Message-ID: <20251209-b4-vmalloc-might_alloc-v2-1-2462ba26ead1@google.com>
Subject: [PATCH v2] mm/vmalloc: clarify why vmap_range_noflush() might sleep
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E2A5140005
X-Stat-Signature: e4ij4x4mtzxx4mjprp9g348i1sxzanp3
X-Rspam-User: 
X-HE-Tag: 1765259057-689133
X-HE-Meta: U2FsdGVkX1+YD+8YwXj44GMdVYTcf1lXqWNVkz3EKSMsa74r8ft4veXRk7YrdjY4A/hixT7NVJu3CXZSbUzm1eU5uvk+O7pWFXN82qnoUuvHJYdbGqqPga0eqNH8cpe5w0ROlO2nc33pasrpW/yLbCHjGq7HMK+JEcpxOLabYE37q2houphxIGAnjbLfE84EyszsiVemX//f/kOQwcBJsmqZ3Ot6ubjgP0Oj7TwBzvJ/Cnng2UrCHYGTBMYqHpss1WOkQ3Fsd+CLRE3kCKQTSFMremPFZdFJ+IopGQBNOIFhszua0nRQsR81yZiVTRkH0OkrLEcswg2d/yOLQz7QDDeTa98Wo6ne2E7yxpSmD05TyHlm07x/1eqpVzHIe5CVf+G+o7TV87+xCj6FBiS0viAh3i8DJadkncTlEgl02U6wc6OkCl2AvPL7E3ZioKTSvoXghaDdTwmUSGE67LAA2Pm/qdAmsWGRHckHbTaIexGz4J/j1tgZDWW1ylzHwakgw9k7V5J1upbFONTeNJ1n+CEUZSg14Q7ew2To1vN0Y9PEgcD9N54hlngBgiyedxUeh8r2PlD6uoCpSP1NodQUC1ZUcWZS602HW9zmfbH0+tX/jFwCNxX70UDC7MM2WqRXbtdmQwdVFWnP/UNNx8kRRNqzvixfuCxElkCyr5KVcFfc6ljWYa2i2eKpG6x6D28QN5p9Q+la8fCQfBsDFcn/Dx/IS6X7KupOVN/Wz7MCqIGWkIn2fHQbu+i1vMhNB5+kItPOJCOZZOL6nkY8lHy3Nrf5RUDMYKna7WjbYn8cWIcoZICDVEisUZZWj5Ywtb9o8Jz7ED7w9PeHqNe+iJHyUxoDXvS4S3MS0iRmqlUrE69tijvLuw+jPwWqt4vd1T+gyEiViHK8AITF7CSbygsLP64lMcP5XngZFUsq90T9m4eGezb46tOsM+k0QHp+hE4n8ssVTvD3znRQL4SwcEX
 ozDHmggV
 7z3KBeP0fNjYNPbSg6XENyFn7/81fLbwJE9ETiWveMS4WvDeDyAXM2mUAWR53FVx2iF6y134TgGJuek7uvqKLD4+BR+iijAEaKw05xFeDY+8lVPBdij2uH23FhBO1Im1RLv/X9c2s0GbrGXWO42MpTsEE3wihpyGLtM92nn4YC7bCNEDb8ATyfdaCpS09AUk7wnZFP999iRUtP7HhJygMJkdhKp3vYGGQgbo3GR7EZtTyoMabJcStmqsUxcpiDLv0d/UizCJDw7ktUKQOw8Bi6ePLu6t23k02IhBE9y7q7nDnub8e3Km7G6WOpOk+YN4tR9oklhE5TpFNxTyX56Z1A/6K6YXaWxXgot80430W+HVf0/DgyddTJeS26kJ2drvxbDZ3gLxT3dINbSDxFYq9u3dnqi7rSBhSlo5tmF8k16qcPRI9elgzj3NWqyLfejzFip1jHiYK9q7PoT+HRdg9BV2Pbo2IopG96GcbmHPcKkoR70Xy8ROwCJYdvjuehwKp5/bpfGY++jeQc48VSJ1ZMV33rOIGBRsqlkdiVan3NnUWmaGMXNNhbP/qzDpFqiW8+oQ9/QSru6zyUXI4MfCvVZh0WxZURAPwHL2WXaPSgbrfwN7Ph916Llr4Cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only reason vmap_range_noflush() can sleep is because of pagetable
allocations.

The actual allocation mechanism is arch-specific so might_alloc()
doesn't work here (what GFP flags would be used?). Hence, just add a
comment.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v2:
- Switched from might_alloc() to keeping might_sleep() + comment
- Link to v1: https://lore.kernel.org/r/20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a53c7462671bdd896f95712af71398ffbe22fb80..c23d378dd4446e2784505ec3d5bb9568fb0d3c9a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -305,6 +305,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	int err;
 	pgtbl_mod_mask mask = 0;
 
+	/* Might allocate pagetables. */
 	might_sleep();
 	BUG_ON(addr >= end);
 

---
base-commit: ecc46e02e0abe025a6e840cba2d647f23fd1d721
change-id: 20251208-b4-vmalloc-might_alloc-754a791e4e10

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


