Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F47CD98F6
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 03:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392C96B0088; Fri, 19 Jun 2026 23:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344256B008A; Fri, 19 Jun 2026 23:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2331E6B008C; Fri, 19 Jun 2026 23:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E67926B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:29:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 520D11C2D9A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 03:29:43 +0000 (UTC)
X-FDA: 84898861446.20.A665348
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 73603180006
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 03:29:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ma8tPoxQ;
	spf=pass (imf24.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781926181;
	b=DbvgbAkJLZcRT31U6lO8pc3PN9/Uazp6O3GCUCvmdjeAdzj2C/irUL7OgLSniTaHL6VvL5
	1SjWErXYnZgAZxSuS+TY6Ej8OLxKTAqD2mvdzMwxr6qZiRIn2UlY/CN+htmXmG6fbK4dpe
	x688C4Ozzps05BqdlA+VP4tWysHSdo4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ma8tPoxQ;
	spf=pass (imf24.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781926181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKO/bKY66Ocp5lpRa+SnULzcfr11NnLnRjMS8RVn2Cw=;
	b=bVH9Gu0LcYqo7x17bVkNu59M5kvU2KsPw1TLUyEWER53LbyIadRbt0ivSwg2zmOHNUGAKr
	fAtbY7o7sEWfXHSBvrw87Kvdj8BE5/KXxfJlYQD4FQ5AtGITiXoKMTWngAU7Nz95OxieOT
	ivBWAWqN6spBlUgp1l0tJxAc9jZvJj4=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-46066e640easo1623602f8f.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781926180; x=1782530980; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKO/bKY66Ocp5lpRa+SnULzcfr11NnLnRjMS8RVn2Cw=;
        b=Ma8tPoxQhraZ8Pokqv40zcDdTZTzONo72yjZ6JNbZwYwVi5p3blh8u9NrBDRmpKSmC
         rFZjsWmrhXDGS7gHxqojw70xA29J3JQxPTp3Oq9srnfvvZmA5ut2upxaGY34HKKgcw2w
         54K8Zt6KyhlrwjQnNTq+k+2shGZehq6EM4Y5kmgeoOisPmBADxyG5M9F7Z6HfbUJXSAe
         Ruxx8DO0PdhuhnTBcl/zCsZ5CjF9US67w6g4pNfA7VvI6yhH7ss/yC3C5TiPf3lhM6Ai
         LVxvgPqlwykwNsXa3F3MS86iHXnvo/sqEzElap7y+8Mg/R8JuEcKaRzEmu5tFU6HoDa0
         0AuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781926180; x=1782530980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tKO/bKY66Ocp5lpRa+SnULzcfr11NnLnRjMS8RVn2Cw=;
        b=Uuf36bN/5/6Ho2elwktv9VLrFAWVdugDzWfPO97YsHgDkN9YNVpq99SvceD8be1ErK
         8PcXr4prUcD93XzoAxQT5NlLNGZOQKhEAnL1VYPtr+/lmOjHctgoGXWd2nFW7wnhFZi4
         96sIAVf18+zhSr7yroRCqIUVyl51WJbY5s2HVQlnyOSN3bKifEwzY6WO6GCcNz9Z7BgM
         o1NRPHj22HFqcp3NdkGgG37MgInsz0uPqqUWDc1VgrUfEjMrBGO76vMmgyuodlKhXLp8
         M4mgyLFKf+OBa4yliGkm1zGyNnlSFA4oZHMXkjgMj/yk0FoEbXNMgnRHk9fe0tI9FCob
         Kgqw==
X-Forwarded-Encrypted: i=1; AFNElJ+RyRY/8esPegf1mE9lc7shVu5Pwh+Po31GBrncUgxaaf195//Gm7tCRMCvhb+BxNAaqrWAwPK9QQ==@kvack.org
X-Gm-Message-State: AOJu0YwKb7jbjBjeFsPpsZccI84aYAkheqWjs8+kqOSfFrQByzNCWKUD
	DqLydFhG/zSCI09/8BoaXCSddJTRG5q/doNuLZPKxQjx2ow47yjVOVwM
X-Gm-Gg: AfdE7cm+q6ZoPRxSsbEeahvqnEkufWsgkmZDqm1XGu/tzyAlKfiwti7Ms/PFVy3IM3i
	2neBME+ceaOS8DS51+EycYaAb/11paOyIFeNF2kMeDVP2WfRkTKBeLA1lFJp5SiRFdotTZGe/SG
	M6M/Kgqw11tlx3RD6ijjEzzT5NPXqWG5Qa0Ohn52kTOY5GcN/A5TVtG0LdYgqhcEMdYHkD4gPRh
	GmKyB4oh7TFh4YmxUSIUdiPZqu20zI4sOlIJ6RRJiblbCDW0kSQs7tYB05WBn9igXmvPWzUXkBg
	PY8tzoeXLJrPMtmghAVQ803QXA4bfdlN3ZYUPrX4goeuAFY3fC1OgVy3UcgJrpKvaD8Ln/bGED1
	vJAWtqo+mFMpL4VDTnCuRhzk89hP/GwoIOOesccL6PklJpVMpJhxskySrzj0bwU/nSaKQbO8m6C
	9j2MsnssnCb1E=
X-Received: by 2002:adf:e004:0:20b0:464:f0a6:74b1 with SMTP id ffacd0b85a97d-46509d57e7dmr7848435f8f.33.1781926179740;
        Fri, 19 Jun 2026 20:29:39 -0700 (PDT)
Received: from user ([104.28.154.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm4475001f8f.7.2026.06.19.20.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 20:29:39 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>
Subject: [PATCH v3] mm/damon/reclaim: fix potential memory leak
Date: Sat, 20 Jun 2026 06:29:31 +0300
Message-ID: <20260620032931.14281-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260620003557.243313-2-yahia.a.abdrabou@gmail.com>
References: <20260620003557.243313-2-yahia.a.abdrabou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9uiayyhcdww9tqcpqpiyjd9phubqdcfg
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 73603180006
X-Rspam-User: 
X-HE-Tag: 1781926181-732047
X-HE-Meta: U2FsdGVkX1/SncG5L0wIrluoKDjQj+TEO8lIMF9DoAqRQE65ZllZNIEZL95CBPYqIRoEk3bXdd/4VwlEkA04jmhwq32GhFuH5I71tIo0qHW6Eumh9TVyTKYwXw7x/w7h31p5PVkBJC/uSy5wvt1i54yP9+T8NvfAphnmRO5LWB0QBdvg/QonTnroOnEOIvi3QVkEwO7UJrP7kZTGAkae+5PRpI3VgUXla48RCu/bh3kskdfHdqgfQTFs08m2WAov1vW7dJFqMG6MghJuAZ3Q2nkqNXsFIwC/YrN1RJpUmT9iq/1siWClQgkgVch+HY3LYM2NLB+ppyZsP6vcS+7uCI3I0XZb+zB13R/WNw2JnGA1jy1NSBIfVmP1jSHzZEMlQK2V72S7d8RAVpOS9cZ2885zkr1+1kUnZj+UA6vfO4d4pwt2WN6Zf+n6GX3XcnbxMOgKW5ZxElaj8hHQd++vJxnDSzQ8Clab/pz7AMtisJ7MHbAnruCIkbzcRU/YfR3Gk4IQS0zi+JvIc+6gKo6+RX2cLFGlB8bZhZ9l3WelnNVWBOz6zp+w8BD2XeaVlzdfvOJmFG9JRwkXp8Ctg0QYrl/MyivY+ueXwT8pBqjc2P1oVeBYWRQVMQ/miREg4DVEBiy+b4Lz1kfaGvTM7txCD7/PdeFggwqpPz7dv262dnbhUEggtxeWWGrgCS+v9RGUHDSfCheGvmhpMitIi9wOqKHuFOy5gOIBXh/+olVnYG8xGUS5NpIAP648USXKn3Ka71qklCOmiZ+JkbjxcwU9S9x/iYa4rhiPRshto0RPR6JGU7TBCyxNu/fk86iyF0/8tzh3ozDiLZRrx57kCw2ZpqquJ+SJBAbMumDB7fALZmNX889MdT1Q93ZvyOxTZB6k/OT+p4r9bZ1o7sViM5fAvXizklJArucfGoRVCVShrcown9/ovtfXvPMB6+bPVGe2D2bCXIvwEuE+Cc4Ti16
 TZB+ZAmz
 rEV0K/ePr+S2/Nv/0l6D99qA/3e7d4729MFzWdoaus/0hitLy8rlD3PszABmNlDfZ1u+xSMjS6o5GSWwJiTLWir7sCKX26Ebl8ZCVFQ0f/mwETDbNYtPzqJPKs7QMDzRNQCxGEgVppLw0gdXOal0R100Ypqvsz/TWbupmOzjFPhKAtxLBcb9HLCikuwxdpfPa1g03Di4comiNKnCHaRz7M2gfeSnBzHBQbdmMtvw7sEcSxdAd6zxozZUQDLM2FV+y5o4gIdQ2qxWR/b3R5ZREcKDyFRfSQ0OCgJ3I4hpJLOdDNl6buhx1W2XTKV95reJy0K84PKt1IvzvV9g1J1zoU/eupMHWW3o0J5f6vToRSkB3v6QS5LsOuMtidfFWOj8mbTJSTND8xb2w+JD8Z85rra+gzzNgMzgL3CNpcBAk/5XTQpBI/x5GInHJ3/C84VqN6J0T/9YQ7NsURAr8UEb+IuLrFiFjXTYExq1CsaCohrQTNcZjRVC40k7x8upvDMviP6CgwOxmWK3hcbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

Fix a potential race condition by locking the ctx
then using damon_stop() to eliminate the thread then
destroy ctx.

Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
v3:
- Add a mutex lock to prevent possible race condition
- Stop the kdamond thread before destroying ctx
v2:
- Remove early return
- Set ctx to NULL to avoid a use after free
- Fix typo
---
 mm/damon/reclaim.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 6601b08996c6..ec5558b7da41 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -480,6 +480,15 @@ static int __init damon_reclaim_init(void)
 		enabled = false;
 
 	if (err && ctx) {
+		/* Hold a lock and stop the thread to prevent a possible race condition */
+		mutex_lock(&ctx->kdamond_lock);
+
+		if (ctx->kdamond) {
+			mutex_unlock(&ctx->kdamond_lock);
+			damon_stop(ctx);
+		} else {
+			mutex_unlock(&ctx->kdamond_lock);
+		}
 		damon_destroy_ctx(ctx);
 		ctx = NULL;
 	}
-- 
2.54.0


