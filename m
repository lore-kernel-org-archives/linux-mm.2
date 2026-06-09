Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B04ACD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4C16B0098; Tue,  9 Jun 2026 07:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD0D6B0099; Tue,  9 Jun 2026 07:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F042F6B009B; Tue,  9 Jun 2026 07:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E10E06B0098
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:36:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2B131C2083
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:36:10 +0000 (UTC)
X-FDA: 84860170500.13.94A74FD
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id D2F6D18000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:36:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cp/xdrFb";
	spf=pass (imf16.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781004968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78gCuAHbgodEfjkwRKqmw0oYajjv5lRliBK5sAWYFv4=;
	b=zf8QhphWnPWMGexolw4AHlKbrYKbUxDQZSuKOq7zCDqF34pbT364yAj06TvNHDSjU5Hp1s
	8+KK9ax/Ow1VwQ558CP4RVtcJOkWy2G/I5RaPOkYUYtreJ+PaQ9e8UmflCQjdYVfdyULCI
	dJreasrgoN6NJDVoMRmC7qAAF/GJ0BI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cp/xdrFb";
	spf=pass (imf16.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781004968;
	b=mPbLK3uUQV3l7ufPPVY2Ht/RpqbTV61+X/E2BMNTRyrQ1587xhDpY+tcnMi8IVnyzIOL4T
	LV2sSLeQUA4iqZVMNZ5GK/DYqzZcGwD/t8vn/HO0/7+YQH4GTR/utD0e+pv7tsMwq1GIJs
	dyVGODDxnT9cRFzHf5Xt4Ybtr8M1LFk=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36baec934b6so3554385a91.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781004968; x=1781609768; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78gCuAHbgodEfjkwRKqmw0oYajjv5lRliBK5sAWYFv4=;
        b=cp/xdrFbehZC8C5Ko7J/NPNz5d1JinfimvbFXNgtXrprpTZdiGKhdEFFvmxR2hjddN
         2MYNpGtRsnUA/mL2hGd844EGAJ1UJ2uMY/PCHqgFrai6JqNJfJqSNiZ7NQ0C/PZY+EM1
         p7IW5RlQVn+ld3HMECR7Q5sTVQerW48stzLo62V0TrWTr92nySnTY1kUMUcG7pyR84LJ
         GQfkg17invpXKAm49AyujzdrVzlXfGdnnpmmEssL4qINI8niV1JN18bH5S7n0XoJHbIA
         PXostgjLqCM2jY3upnDpvdpFYuM3V8OYENnWiz1q8OzXVj0dZphN5vZWdWsJdQ/+XPaT
         ahMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781004968; x=1781609768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=78gCuAHbgodEfjkwRKqmw0oYajjv5lRliBK5sAWYFv4=;
        b=pmDNK/W7VmwoofR0MXlGdyAy5+1cC6Ln9e1wX9LK5gAELxFr6phJ4kvmy8TEkMUldG
         yyx2zF/fVqojhXhDQxKoGkCxCGjxzgTmY7P9LjIL5eAgjZaiz4jfMTMRmSsJhw64iqYa
         +1giLlrzo5nycBtXoqsGr+8EIkYVcFsN2a9APPWKbMjOovg84Fr7oyq8s9xo+YlCpDFB
         IdaiZtE2+F4WS1sIhUDwsWfssgQLZjca7Rzegk6xF0X2D5OxQXstR+PVF/JUlCMJl4Yv
         sQtZKyXMhN4rNKsDpCHEF0lydoqG3KkiQDDSsgWmhwvGkw1Wf/Icu1AQ84ozn1m2WLug
         jBhw==
X-Forwarded-Encrypted: i=1; AFNElJ++elxnD9enp4CWpOH+uD6DCVi6V0J6p6Yr9+tuK4vtjUuPsh9p3FTxBrWBxuU+Nc4fXp4jEa4Wgg==@kvack.org
X-Gm-Message-State: AOJu0YzstAxuhlGWjdDASMFDh0Xb1stfXXs8Xe7zlAPnBjUNCFie6t/q
	U2EAfSUD5wyWcFkvM7ojb9fn8SnNQGLrby/d0pS+QPjkTH6Fg0WfV2OZ
X-Gm-Gg: Acq92OEnEAo0KeOxjyoRCuJJ2twyBbx7DA6FR2jDErkxuZeZ4FcC6+BLNxZYPBuC6YO
	0mwIDQMDq5HgRuCC3S4GmN8V11XGSYdCLI9rURakv3QzSVRRszNplH/xVUEyKMrHOS6mjS71QGn
	qOJRbdwRr9VLTonpxpmJzMk7KiljTdvvcivoCssNnATrXaOnqaa/23loxCWPrjPNHfluNKPDZH3
	riLrHrGfB5PTau8Xioc/6TbipAOWpFtaXsI7z6o4LHn5p1K3FcVr/+7NSMbWuBTG7p+Vslf6oTb
	D0bWXS24sIlCHnrI7wWuuuYBIAKDbuc0aL5GH1z7AF+BCZ+CRx6C5nh0adjWcfOq3NFwP9EP+4C
	+e3OkXAhxaZYCyBEtqROLaJ1BRcWQdhpKz3b7wOoocnQgEkuZN8pNPJDGGDDRnnXlDXxCvMZy35
	r/bFPuf0YxH9497l9lR5TOFqkVZ0wmRMSVqTbevYxFWe3Ldsi1bA==
X-Received: by 2002:a17:90b:544e:b0:35f:c493:cac5 with SMTP id 98e67ed59e1d1-3713337027emr15348877a91.16.1781004967777;
        Tue, 09 Jun 2026 04:36:07 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6c668e98sm19655292a91.5.2026.06.09.04.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:36:07 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v4 4/4] mm/zsmalloc: document free_zspage helper variants
Date: Tue,  9 Jun 2026 19:35:20 +0800
Message-Id: <20260609113520.3507783-5-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260609113520.3507783-1-haowenchao22@gmail.com>
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D2F6D18000C
X-Stat-Signature: 5ora5ajoyjujwiwoq88h334kwk7x5xfo
X-Rspam-User: 
X-HE-Tag: 1781004968-829161
X-HE-Meta: U2FsdGVkX18DLdXf3ZMGDBj/E+Hi36tOp0ddjamfMdcaBLKuJ6wAE8Sei/x9dWPyByg4MhmOXs4Gs0mDjrknScqOXp3Oq3PsSArk19gO5+YbN53TcbHmI9T/4pU82HCipgpk1gmXTbCyLYukixjwmS7uVHXQTOvAWG11C/o6ccX0j6nquX0v+aXiVoeBx8CRW5btgCAPwYLZV12V2ksuT6KM4Sc8oZnGv7bztj8xJtP21kJ3FaW/DG3x4YWfVyCQSBHRp6vuJNCFcWCeEBqm03E/I2KrLr1wZnYozdxrGVPXNmuy5pnc9JgqE/9hSuTkwKfSOf6qMccsd81uzxm5z7s6YY0Fc2XOeO6AjsNsxUre7NLlXrqFrTN8QeG/QjbM6TCopSzcV6/FG4pkmjS8To4Hky3O3zSM2yepyBPlgoSh+/4CHvdp22NGosFwTd74SnGgyHJymRzOv9T9bcqOmmXvR3+qP4nv47QKJ6QVQ102Da1YwG8QzpXW3pI4TuEGiow43Ejj8NsCNfVFPA1cpafl3XZGYIW+n7S4bbm1rvbP2WeElGPXEIhojIoKlRc9ehb31MM7EIg+tgOGmnOJ81xTaHeSFAaVsNgEKyJJT29i0+3uKFiRnRQWnZvq4nQAzoETAfyFjj5IyDYVov4rJD7f74uFB9fvAdYH1s1+pMlFe53CNcMdbxkwNPvWAlc5OzQ43uh1+ykZihEOpGOd16wQE/S6HB241oxWqjAvO96jgliRc0l5KPM/0/TNlXLr8+XDUMsuuHDHszgTvGneXthi1h46MdK75+wZ3AOKLLLriDFQDtHJthyMMYUxj69O187Fn3s4nLHdPctEbiJeK/i4UHqk0vsutwsOBCrT3o+UcAkYq5jsSLMKmj/IgyomEyGSMA3PoK4SdxoTgG9mOAhqr6HF7IhJwTBZH7vWr7kEixdSUfgB8xZ0ghB8CM/V66LMWk9e/3dwcenEQ9Q
 0dRcG+TR
 I2cnjvCTG3Yo7xbQ25PXe+p19eddHmGMSIoKgv2dxlKTuy6JlCg+7Oo7pShi6Fu7tI2+WM2P3zRyLJWexLcbGRgXPdJx+GxDDYv492XTeBWk3XEXKlAuB3J/zz7Fr4Wq4trPhhkDYzgFq+HEqqlvjOsbHNspa5ftTBYTOwz3sB8nwIPxFRNjlaCNXtP1LdJNoHOeb5UXklWRi/PvnBhHag0n1aum1Mc4MADpfil9hZT87UW/Lm4UTlQwzOP29E0ZJeAycY5glWPekLvNp5vIn95SbERzdZtBTH+GgOqTsn7q1uV1NXwXxpKDpAfF7EEiLKzf4/fT4gVA/euKTRJfN+P1HF26gJA6lDGCtp9S7OlcbJevr2qJFyP6NnYT3azucJoqgB4sp+1hVz37Bcjj3plmhXM1ZCzVKl8jby6mzv2gxAHK8eygeUup8zuMhZx8TCnN96ibh2u5RKXP2phgBdNHiUPs2fPrOO4MPV4AJMOkc1cv0lC6AP2mT6CTnwLShZLTqz1cABuEIJIWnlKoRqZUGdFge8c4Fcn5A4CrflFr7xkFj0ztNNM9TgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenchao Hao <haowenchao@xiaomi.com>

After splitting __free_zspage() into a lockless core and a wrapper that
does the class-stat bookkeeping, three similarly-named helpers coexist:
free_zspage / __free_zspage / __free_zspage_lockless.

Add a comment block above them describing what each does and where it
is used, so the names are not easy to confuse.

No functional change.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 1602ccb6d814..c0edce381d20 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -878,6 +878,22 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
+/*
+ * Three free helpers, kept apart here:
+ *
+ * __free_zspage_lockless(): bare core; walks zpdescs and returns pages
+ *   to the buddy allocator.  Caller owns all zpdesc locks and has
+ *   removed the zspage from its class list.  Used by zs_free() outside
+ *   class->lock so the buddy-side work does not stall the class.
+ *
+ * __free_zspage(): __free_zspage_lockless() + per-class accounting,
+ *   under class->lock.  Used by async_free_zspage(), the worker for
+ *   zspages whose trylock_zspage() failed.
+ *
+ * free_zspage(): full wrapper - trylock zpdescs, remove from class
+ *   list, call __free_zspage(); kicks deferred free on contention.
+ *   Used by compaction.
+ */
 static inline void __free_zspage_lockless(struct zs_pool *pool, struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
-- 
2.34.1


