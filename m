Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3806CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EDFE6B008C; Fri,  5 Jun 2026 04:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E496B0092; Fri,  5 Jun 2026 04:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3B36B0093; Fri,  5 Jun 2026 04:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9EF56B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:43:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B50D7A0B12
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:18 +0000 (UTC)
X-FDA: 84845219676.09.1614BB3
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id DCBFC16000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:43:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IM2UpROY;
	spf=pass (imf08.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780648996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n185DjbA+W+3OzU5ke/OSZXijWXnafvOkeAJL8VmlKA=;
	b=8hgE7t12PAZwua6c5lfibZAYt8uzmq2YmIuJbmvnFa1ZtewgkVst+yrehF45Wis1AL4SPv
	HP2lM1ft2NeNSTDby+QnMHrV/b9R06ztKDXzrjoEvG3RLAkCR3bp0znRMORZ6yAfi+4GSW
	cG88wzFAaRJVFruZV0VSxDGCAiTvEmM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IM2UpROY;
	spf=pass (imf08.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780648996;
	b=mE/1LrB/4rcHToYBQclRQnifIbSVmjdNPNWTJItdP9jF3V1dAWygcV0nOBcouwYOzUelZ9
	Pb/irpKifYt1G9V/HUSE2JQ8f6NGG3V9cMUmaS6+KKtSlGszlFDq5EaUmPd6ZSOylvyUki
	RC8NyfzoDgzYKl3RdROgA/P5G5QdIfo=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-36d9794d82aso1182434a91.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 01:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780648996; x=1781253796; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n185DjbA+W+3OzU5ke/OSZXijWXnafvOkeAJL8VmlKA=;
        b=IM2UpROYjoE20uCkNnFE9vPBuwtRrqhDCQlA63ua7wEvGr3nekLKilg0pKYcZISOos
         e9yX54GPZyorJZtzS9L/d6PcbNrz70zVk4tcM7e1hE8NW2vHMddC4gNBM7vGmr5htKlc
         MtsVPQlNByrcTn7sSi0vL1Cw4kgXJLiqnFXwdHg6PNnVV9nYbpRJS92I4C5DKhJ4T7LX
         LI07dZqKiO30QFAcZm1Sp/EjIL4hO0pGEfq5vAfH5FJsgUxEq4hKyNop0ZHnyibIiuRK
         ipnGd0HPUnWA2197x8jru5ltpvKjll+0wUGN1HJqNfSpqVuFwqp/ehRh6dWeKfPvarzF
         8g7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648996; x=1781253796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n185DjbA+W+3OzU5ke/OSZXijWXnafvOkeAJL8VmlKA=;
        b=dhq9OUnevnXnvEEDREt/qu76KJ9SuL9+O7A+GaKl0qVv2UsyYzUME0uu1k48FyFkmR
         zlVc9V204f6Lit+kFIYPy3KprLAmDrdwRBbWujg33p7+1kcOsCSL90tYGVd7KplM0MiN
         fKF9Hst3ZC7TIfBR7xicIUPT4kCOsQDj6ApEAXJq0OAvJUCAh+0cKv0ucCgTXUe+Ss5U
         cM0nGZU6/drvz+thxnRQZx0vfIbm9Y/RPeo8C6MGdOAD/YhgvA+JDcN3j9Ai3FKHzBHS
         vOMXS5UR/Uvg25iKc1fh/ywPOyyytL2k5tLxQhCadkndPd/BHTwsn2kydVWe7aKWV22O
         CIGg==
X-Forwarded-Encrypted: i=1; AFNElJ/BTlKPc22ZOVADGIBDdGZJkgtmvRrh02pd8LvfmSS6D2CCcSsdeSHj5UnIxshCj8l8F+nJroAX+w==@kvack.org
X-Gm-Message-State: AOJu0YyWpvfQ/+wIR7DaYlLHDkpuKm2uZFLdCJK1khDx0P9U7cuwBZp7
	tPWir2eVW13Pdd6xeFKf88QDlRH5l5xGZUh9ffoRa569vzcgmhrnROQ/
X-Gm-Gg: Acq92OE5JtOhDJpDV6CZt8yO4Thh0fi/3cha79hL7iEorSoC/kiCMqHnv7/AA0/i1vP
	w37nYBdZ7iC1hrHx71Q8N7LjInvyc+9b+On7UHhU9vc1atFxJOLnighPMD8/ef690aGG0/Lsilh
	3/Bq/jJ1fUenRrCLGkJsULXR8M9jyYIJfpm6iI8aehvRCFS7qa7T3qlgOjI+JIuYGAK21GIDLV4
	s4hjrL6LHQKOnUuRtpXkIueTYWRY92BYA/J9dk5or/7LLBORhEoovGDFDZs2uN8f6QPqqisFsct
	ezLHOKg2j260J95zWjkqsnu1/yLCw3hYnAvsQ4wAm4sisIEsA0VMCUi3amI/ShQvG6mL6Iz15MQ
	rnCO6aPjtE6dLE5ZjHFm+5uyt7qYYfaDChXYOF5pzaFi+5+TLM+q5CUmaaOGjk2+wo4zr2SvM09
	zrFQK8SsrUpQIcRL1T4SRtOmM17+36dg/vTbzL6g0YWfNzm6uzBA==
X-Received: by 2002:a17:90b:57c4:b0:35f:b647:d98a with SMTP id 98e67ed59e1d1-370ee64373dmr2739847a91.5.1780648995812;
        Fri, 05 Jun 2026 01:43:15 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3712fcb2607sm926632a91.0.2026.06.05.01.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:43:15 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v3 3/4] mm/zsmalloc: drop class lock before freeing zspage
Date: Fri,  5 Jun 2026 16:42:41 +0800
Message-Id: <20260605084242.1549811-4-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260605084242.1549811-1-haowenchao22@gmail.com>
References: <20260605084242.1549811-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DCBFC16000D
X-Stat-Signature: ohozhkth3yyuum6ft8ms73rnrduq6s1s
X-Rspam-User: 
X-HE-Tag: 1780648996-41556
X-HE-Meta: U2FsdGVkX1+Cf+p3VpYDGXsfmtpw250u1y7PIuE5uNVNso2DkjCSE+NtyUb3R1yy+6qOiEQqZa97hMLMEzC/LyuvFHx2qShDwZQtazgwAP1VM5u4P2Q72S7EouE/WBgl3vgREPpzgf4aMUKPhHTXUex7D+OQc0RaXOoCS2RmG7m5glS6kE7CwAOvCwe2I131C7gre+pJQ2h2HXI00aHGf4n6gExWB2tr07Yb1/+MyxCO1shBzcgwKEi6v/bax4eKhN4vZUUI8MYniYiBBp4opzwFPmVUNiTHe4xl+QHWdnAnEUIOFTS4DeNChlTZGiP24YzSJVWM0jpIR5M4m2TBVnY2M04RUzzi5OxnbJHdxql8m2h6/oSRrGrvCe/jKamIOzms9yvU0jNCdbmIzAMg8PuggS/AgfjFrzdjMLkFx9jou/vmiqFZApY5vtgvcra+2MOFA3OSmeBLPvOErjCaawo9V+NbbPECHVTaq+NMPAV6mcWs6V3SC41qp4dQTPbCY/5gXSoABcZqkq2D7nkiQZOFZuyjaNDzTXhAFgjwVRkTqkPHRWbQVsXJL62Qu4+fl9LId/rqDGI5FEFbLLKmnCy9wzVZsMnqKw3d/P89IhyeVArwMWcU1qdO6Tis46lCxILw9iU1GiW7ipdGAYDQk3GrQXZy+FvnyoIzYwYQccMW5yq8NmjvtVwHIR9OPimgHryY+fQG09bqhPJ1zSyTfJMPt7zY6z7KT2jEbnuHEgRM+nBNiKHcnk/2yOWpsbxI7CZife+yU9RM8oIVrVwA7UVioKfF4q5iB8vVs8EamdTRkw6XqfR5X05ohqqXiViNYPCkxkPJD8kiBZ5nRU25zWKBHOA/nszy3evLGOdIlI3MtHJgFrHLNc8uxDxj7wESu5N+K7V07Xw8UM3iFeGopHAduQ1sATPL7nveBU1pcSoX4tYheoKrSzncGbynY+32J/Ya0fUbWDZOFLC1OGy
 7UV70/1X
 bjQMMTDHHj1R3rybTrLY0jd84b8lWFc3vW6+ya/tgike6dee7kve115oRObxJo13Uc+5VtQn/74iKOuOjsPA/SktmHTUZoTbeuW85il5iuypnwV+B89QLp3exAVTSuf8DlreHMmPyHVwuXxBBcbu1WAgu8JfcYiujhmT44SzQPQJIWQWUI9dLqMROqPm1PqgPdeOz3g96vJIWI3VCUYdHWneA9QKe9rN+jrwgoyO1woIIN8XADTxWmJFIcPkU5gYfNybHehk7OwR42oly0/5wYfUmeN0WmD6tfqopzfL2HvBRtz83EQPU/CPpMJPUIuw1HY2vfpJhKw46BQJmGvCxGMqh/GNGfKTiqoq157e0b9iKXy8VFeglqJxLsnsNoW5J07cZF0MmgN8OQnSSyr4/EiOdk1yaCdwDYID/EbPQxre/W5Mt2s5A8tKE/iRjpRUhxRzgx//bSFnPNxypPSfyTk35vJEDSbl9031d9xBI0mBexbISrwfkVt1aRsmkQp/PoyEx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Currently in zs_free(), the class->lock is held until the zspage is
completely freed and the counters are updated. However, freeing pages
back to the buddy allocator requires acquiring the zone lock.

Under heavy memory pressure, zone lock contention can be severe. When
this happens, the CPU holding the class->lock will stall waiting for
the zone lock, thereby blocking all other CPUs attempting to acquire
the same class->lock.

This patch shrinks the critical section of the class->lock to reduce
lock contention. By moving the actual page freeing process outside the
class->lock, we can improve the concurrency performance of zs_free().

Testing on the RADXA O6 platform shows that with 12 CPUs concurrently
performing zs_free() operations, the execution time is reduced by 20%.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 88d10f814da9..2ecdf79cea03 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -856,13 +856,10 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
-static void __free_zspage(struct zs_pool *pool, struct size_class *class,
-				struct zspage *zspage)
+static inline void __free_zspage_lockless(struct zs_pool *pool, struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
 
-	assert_spin_locked(&class->lock);
-
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
@@ -878,7 +875,13 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 	} while (zpdesc != NULL);
 
 	cache_free_zspage(zspage);
+}
 
+static void __free_zspage(struct zs_pool *pool, struct size_class *class,
+			  struct zspage *zspage)
+{
+	assert_spin_locked(&class->lock);
+	__free_zspage_lockless(pool, zspage);
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 }
@@ -1492,6 +1495,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
+	struct zspage *zspage_to_free = NULL;
 
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
@@ -1502,10 +1506,23 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	obj_free(class->size, obj);
 
 	fullness = fix_fullness_group(class, zspage);
-	if (fullness == ZS_INUSE_RATIO_0)
-		free_zspage(pool, class, zspage);
+	if (fullness == ZS_INUSE_RATIO_0) {
+		if (trylock_zspage(zspage)) {
+			remove_zspage(class, zspage);
+			class_stat_sub(class, ZS_OBJS_ALLOCATED,
+				       class->objs_per_zspage);
+			zspage_to_free = zspage;
+		} else {
+			kick_deferred_free(pool);
+		}
+	}
 
 	spin_unlock(&class->lock);
+
+	if (zspage_to_free) {
+		__free_zspage_lockless(pool, zspage_to_free);
+		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
+	}
 	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
-- 
2.34.1


