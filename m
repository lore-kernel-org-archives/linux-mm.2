Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60067CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9266C6B002A; Fri, 29 Aug 2025 12:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF686B002B; Fri, 29 Aug 2025 12:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8131A6B002C; Fri, 29 Aug 2025 12:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE546B002A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:22:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38B0813A992
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:22:37 +0000 (UTC)
X-FDA: 83830313154.22.049A56C
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43EF0180006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:22:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=RAj9OXaI;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756484555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO3fZfxsRC3wtDo2pgMFNvnPCWzRCeuSrbJiTbqH9x8=;
	b=FSvUspNnp+Gq27X/Wh1JNSe0cHrppB4et9ZsMv/tp0RB/zmuFjaxn1UDR0stiBx3fdnnVi
	MeYGv+7+H1xUUPBP/bJTzgE9NcO7rI5xOKSMhw5m8FO8S5647CQ3xkSsQzdloJ8lKiGJCM
	8EYzCyh2eiKA5OxfViin1Mr6Zqb+Nvw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=RAj9OXaI;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756484555; a=rsa-sha256;
	cv=none;
	b=aMZvh+TtdZjSY33xFUpsIQF/DuJH/uQXnA8IE2iKmFbgXKd18j3iojEBW3Lcj5s9Xo78Br
	h6gFwVu8YIZ2bpSjk50We6GTV8srCTwX0Z+RyMMWrSv4lNMYMqPjlydD9QRjr3HEpKvn/F
	EweQmGrsmbHsAbk3a6zUsdqmQ+g/J/o=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b7d87b90fso10266075e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1756484554; x=1757089354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vO3fZfxsRC3wtDo2pgMFNvnPCWzRCeuSrbJiTbqH9x8=;
        b=RAj9OXaIxRmpEQzTkSQj8sBgoiifPdKv+Hil5iCSxCyW0ps0yIXRH31rf8kq/sgBgM
         DSenOAtTexDdQ5KdHSLCgGu5WrGUecteOJ868XP1TLylvvcszAj+2QYrtzPa5XfhVrxO
         5/mxcc5xWoQGZys3p1iQ0eiyPBGiphuWm0bDNgwIIOcAQmBSROV4xngA4maVRxSRcLgR
         y2K3t1ROOzOS1Qw+tu9JINxzFViw64qRZwuo0ewkxe/nWQZSK8tzcZB+WkuiykEIcG5S
         fxOTXqGTEVkh9fKfLHkaPjZ53o7YNok0uItNVyUqdVGm8fbaTiCL3RTT5y9b2xoh/kTZ
         OM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756484554; x=1757089354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vO3fZfxsRC3wtDo2pgMFNvnPCWzRCeuSrbJiTbqH9x8=;
        b=EFKOXPLsf9NCOizeUtK7w8T6MMXHNelgFs5eH8sTt2Potemg6nV20Uh4M36m7KeU8a
         A+81cKuRygxPKPm6S6kPFNbfYJK3b5wE9lY9P9MozZqCbLaIuKCDsqhWVPEZblrYOPMJ
         /IlcgqGLtA4Sob5UfefKhrYf+ZJUAKgY1liqnZTqHLfH1rbYTninsC/FiDU8n2+ZKGbs
         UttbdqkCP+uWJWTv46UytyRTXRv+MUU7wRdKl8dw/ppDELZXrHMK1zgR6IzaoWRFbEPx
         CZ09kBqpv27UQenPUKla3HaGkh0/5DaobG3AhpbYl2cmY/rQ2q9M/261b3oFUrzs/Hd5
         6Hgg==
X-Forwarded-Encrypted: i=1; AJvYcCXKRNf/yZLuV9q5mn8qDhqI6eK/mvrsp1cn2qNl/DGmWymafvruoSjStmQwVdyN2xi3wiq/LnCJsA==@kvack.org
X-Gm-Message-State: AOJu0YwR6seUnd9dPbidIy2OJhZGnyeG1VTGtypqowBf9mYQq0Qntbdo
	GTEril2qv5rgtiTtqh4G5pMGrilGdHG8d1iqgqS6eF8PR+3BDvCbKY/ALbcViWGPhSg=
X-Gm-Gg: ASbGncuXMNKEd/i+jQ9M5sH0QzZqKrgJCmoFWc1HMSw476420hk6vWTBCv/Q1N7CGvk
	l89RxzRfKw1tFLPnRP24rRWeegr6+Vcnf4s7w/XmmO+A0QhtFGkoyjtlcSiULgbUbAqz3Kl+tX6
	rrwPSLl8sZzLci+U3cWOXFvSRDHvc+piIwI8LrME0MHkc/qN88bH2Y4MM8yoNwKleOWXdv/NjIv
	JazWOTSmr9u/kTQwpEZMLniM4qCE4NXHwgsoFv5c0azY8dMu7hNJGJUtc7xaFz9psEeQQSKmd1m
	V0xOnVXC1aOFDpmN6qOGWl5FJB7taFlO2881idZ6dlolVLQkJknO+jcRZc8WS32BfkQGe6RtQC3
	EmPA=
X-Google-Smtp-Source: AGHT+IFvxH2wrrQOL8qFClFcMXg7O03uzVqmqAkC2KXtyit1y23oMAaMh5LuPNjzPv7yownc2pnyxA==
X-Received: by 2002:a05:600c:8b0a:b0:45b:733b:1feb with SMTP id 5b1f17b1804b1-45b733b214dmr88676045e9.10.1756484553840;
        Fri, 29 Aug 2025 09:22:33 -0700 (PDT)
Received: from localhost ([2620:10d:c092:600::1:954])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7d9548edsm30431075e9.5.2025.08.29.09.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 09:22:32 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosryahmed@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mm: zpdesc: minor naming and comment corrections
Date: Fri, 29 Aug 2025 17:15:28 +0100
Message-ID: <20250829162212.208258-4-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829162212.208258-1-hannes@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43EF0180006
X-Stat-Signature: 39mt1gzmty6wx6ztbow9biyhb11cfapu
X-Rspam-User: 
X-HE-Tag: 1756484555-354464
X-HE-Meta: U2FsdGVkX1+SNDdq1Qzh67D8JjqunNesvDeXVVfUd/Jtgp4DOdsSKPIzB5No2FGlIvJN/MtVmnUtcZTwDF6QTTDQvR45Jn7f0uRMJdkFEhDZw/VFuZ3QCQFT3Gc9+0Bwz7ZUApAp3Pnwlwm12aYXRzR2GjwYQaJ/oBGLS2rivOT/HMbSsooWUOdv4pflOGkAZW99YwbTaPCMSKC3ngrzvDQgbOFPvrDVH5lW34SMiSi6wrYhxXGo8bbDZIF5WNWxhMOZFivKPGkpulr9jisv14pLrPNUc2QRhwGwrfJZ0Jij9kr/yHXFWdTpC+5HIj3IrBnHkoEtUaT3W4YiHXG4lOtewROzdKU/fwmTNmuPkuACpx9x3M2JLXbZeL86ndmQLYP6ozjU0kqioMI0D9vbGLOUGD4+hYnhh62Ho3HNLUbW36H5h2txnuZLLrSUFBBDMDPOJHphiwnvEf/AzmBcNkLQnM9MKYh2bsB7xKnnz3lPBRDToN3tjQmo/+fe0Fp6CdjNQ8AGDZoff4Enr8Fui9aiGJTkcjcKs0qtvHKOxXvwBiBuM8Ek0Yj+dUl8hO0ojFROTTcrpOux4E4CsX6O10EBvwFU8Q0cwe9k/uPLj8IrBVj++rHkSHF9CB72R7yuUfqfOtvHdTTndp8NrKtW8uFbha1bfkEDGKTpq7AhV/QXVVkmRyXcB8ShfEKNStFEdHC3zJLTSOJH6e/++aaz0aU87kvvZlx8zxw6J98U1Gs0zjyJUdMG//96Y1Rsr3o5QRAZWYYFzuychyBXHblh25+vB8dqPssraRi1yiphXQ7vknNOwzeqlxfS4k6BPfwp5025/ELha/FiuwCCJ89A+zX/LC54lYxEXaWccd3EoSHUT1c9c6CakK43/78+APwmLo+LhLgBQaOsktLKnhK+O4gv+1H2lnwbDoBsyXH9Jjy2+fuNtvJ+Zrvj9fPgvlkp/j6MDv4vhULkNUm/ZX/
 9nshGe99
 Bw/wrGrKPYAlLiziJ+8zMwdaDzt2Blaz1/QYIkb4y3PEMv0L5TjDctYrikPc9B4fedMlDbhJgJHjAAInowITkQwBIqC0ua1f4CctOH7y1NWJuiTJWeLyCp1hTGc4yxxLSxua8nBLm5EHAjOK3UTO3XciZI9v87Wf5i+gVo8s01fq9G1Pe52IRg/AR/w1qotEPGaDpjEN/QawfPIYpWfmxPoxMgyg7cFR6aS4L5A0BSzR+4NOGRlDmIC3sXiKSLPo8Q7tqg6UoizSRacZ23mjT5g99oGeX9X+uFU4qSV/9R9ghhIfZEUwrx55vOUsQBuhwqk9+8NJ8/BF/cROE7kPwKdQwvGeYCkCNYWkC/MW+dy9vS1R2jFaVv5RirJRY8iE3PdW96Na6DOhI4AILoWHBuIIacAwUbBCwEh2ZsGlRwZ3G4UX4hEZStSO4yKKWEn/Xqavcb5T0d38C6JHMMUVfCONv9eFNKvfWB/ENvwYP7FuffKBSx8FBvkX00YSSa8IO/7LFRcGyoMgJfXg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zpdesc is the page descriptor used by the zsmalloc backend allocator,
which in turn is used by zswap and zram. The zpool layer is gone.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/zpdesc.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index 25bf5ea0beb8..b8258dc78548 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* zpdesc.h: zswap.zpool memory descriptor
+/* zpdesc.h: zsmalloc pool memory descriptor
  *
  * Written by Alex Shi <alexs@kernel.org>
  *	      Hyeonggon Yoo <42.hyeyoo@gmail.com>
@@ -11,14 +11,14 @@
 #include <linux/pagemap.h>
 
 /*
- * struct zpdesc -	Memory descriptor for zpool memory.
+ * struct zpdesc -	Memory descriptor for zsmalloc pool memory.
  * @flags:		Page flags, mostly unused by zsmalloc.
  * @lru:		Indirectly used by page migration.
  * @movable_ops:	Used by page migration.
- * @next:		Next zpdesc in a zspage in zsmalloc zpool.
- * @handle:		For huge zspage in zsmalloc zpool.
+ * @next:		Next zpdesc in a zspage in zsmalloc pool.
+ * @handle:		For huge zspage in zsmalloc pool.
  * @zspage:		Points to the zspage this zpdesc is a part of.
- * @first_obj_offset:	First object offset in zsmalloc zpool.
+ * @first_obj_offset:	First object offset in zsmalloc pool.
  * @_refcount:		The number of references to this zpdesc.
  *
  * This struct overlays struct page for now. Do not modify without a good
@@ -79,8 +79,8 @@ static_assert(sizeof(struct zpdesc) <= sizeof(struct page));
  * zpdesc_folio - The folio allocated for a zpdesc
  * @zp: The zpdesc.
  *
- * Zpdescs are descriptors for zpool memory. The zpool memory itself is
- * allocated as folios that contain the zpool objects, and zpdesc uses specific
+ * Zpdescs are descriptors for zsmalloc memory. The memory itself is allocated
+ * as folios that contain the zsmalloc objects, and zpdesc uses specific
  * fields in the first struct page of the folio - those fields are now accessed
  * by struct zpdesc.
  *
-- 
2.51.0


