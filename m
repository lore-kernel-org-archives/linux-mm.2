Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51FEA606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=p8aocK17
Received: by kanga.kvack.org (Postfix)
	id 2CCC26B05B6; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F8E6B05B9; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6AA6B05B8; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7D7E6B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:45:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2BD11404D3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:44:58 +0000 (UTC)
X-FDA: 85376691876.02.6E64041
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf31.hostedemail.com (Postfix) with ESMTP id C478420009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:44:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=p8aocK17;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3N6LjagYKCGgQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3N6LjagYKCGgQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793303096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXjoG39Rs48qcptpkOzTtTXdAXXdVfiT7bG8UtqD1+4=;
	b=gAb6xYZaD1cmy8U0OFmrXNWIkV/r69gJ/y5GXWzEIvqC/xzQpcnWXwQY+QAONaI833sid0
	uvJ6cFHP6mu/EzRDD2JrEMuBZ5HdGv81ii4kZlqOrc8JMgiZL0+c4cL2RZqtfqpp2vJZj4
	PHPxUuDXs7aXCe/NKOkYjmRkftR5PgQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=p8aocK17;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3N6LjagYKCGgQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3N6LjagYKCGgQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793303096;
	b=Nz/zgtyDfLhsftD5tD4IsV1HVEaQtsRlFrLd9ZLq5MokbfrqU1eb9nBT7R2xuK8j+UMoyT
	9RFaC+G9GnQmAi8X1dTO89nXGvJYsU1m1iUOmdChL+nOCNn6MfM+t0cUhk8optoUzRUHzZ
	anQll4c1zcCsV4hTsOxeby9IpnwEWIc=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a0688a43d3so1954079b3a.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303096; x=1793907896; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QXjoG39Rs48qcptpkOzTtTXdAXXdVfiT7bG8UtqD1+4=;
        b=p8aocK17FsIn7saS2QVWgcPvBtp3WlNTQd9YR0gQVJvo9em8caPyx504Tve6Q8mh9G
         MsJsheNmtFlTRZtWONSHsCBe8i99GDby90SqMU6BdtgASBkt79cjrbkyUfR1yjTVjIVh
         rgF36IappQg41NvHxLzqCmfOhZr17O5cDN8+KsY5VXLAlh+LC8x4ojFqMx7xRg/UE2Tc
         eSnPN/jbj2G6mBpkLwWpdaCA87CfF9K3i2W23i6CO6+cB/9G5L/jt3nbyAVooiwkTZ4W
         K2hu+nsM93n/glNKUfhq8WscihrtGJekSpV9iY6HDwSOwPSWKkRiTXBZ3jTqk5D8xduX
         /tvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303096; x=1793907896;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QXjoG39Rs48qcptpkOzTtTXdAXXdVfiT7bG8UtqD1+4=;
        b=AOC4h/plIsbVqLMayA8q37/ldrFxJkHC20A/bWrwtvwPM0Bb1lnyLQ7BK040HuNe7u
         1IBUu8vcKeQ+6Rj2Np2fPSEn2cHqx4iq0sffllLFWj1DEfLX645fEmmNc85kTwOkpH2b
         A20wBRdT3I7gy1DAk4L1VBJSDfNQp7p1rxAHjBenGDBn6cnlZ598YWeSJO377vf/3XiW
         mdKXm5QFiZTDOGj9V4FtPMlfPumgpomc394ewhghWc1EEAGzzuKJQOFSq8V1yZPOVtUS
         OSFz8OhK0c4AWniaT5JI0dn01IhkZLYIQzZtnB4vWqiPXfAufPVAfZigLqyodF7AoP7C
         epWA==
X-Forwarded-Encrypted: i=1; AKwUvBz1Ke0zzBp84YNd5snccBVSDwghzXI0h7TPEoJk1TN7WwNSqp/lcXu1ElOwIvV6x4+t/xfAo3uAPw==@kvack.org
X-Gm-Message-State: AFq9FYIhfEjulpn6FClR7RM2cCl/w9R+o1zMumdNEqpWHDhrYkur+Jxn
	yylqBbuNjX9D4XmSmxyur/PQ+sAjrPs3lWt5TkEby2gVuoTvKIq08/qh2Po7uuTGAcgOFx4Su4I
	eOxgEUg==
X-Received: from pfbhj9.prod.google.com ([2002:a05:6a00:8709:b0:88b:de0a:27d5])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:18a4:b0:89d:29fb:b5e7
 with SMTP id d2e1a72fcca58-8a9be4909b9mr128727b3a.24.1793303095560; Thu, 29
 Oct 2026 12:44:55 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:13 +0000
In-Reply-To: <20261029194452.3189365-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261029194452.3189365-3-kuniyu@google.com>
Subject: [PATCH v3 2/4] memcg: Reduce nesting in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C478420009
X-Stat-Signature: dwntsurzh7tik4ckh4c14hczrddaiwpi
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793303097-251064
X-HE-Meta: U2FsdGVkX1/NCxutMZ3TAwXav//Ue9PordTZ5UWcuHlHzE46wkcGEGkJf2vit+B3LQdGkblM88U68kDXMdWLBiCXFue+AXJA2XYXBdL7ZaF0hMt5Xlyy30SuRTmcrumxIpE3VYQC+boSvgOLDMCwLbTGYkv3n3hu+SS6Qfq4QMYujJpHscWKhnLKUcieJUW5NQ8GOJFxEU7qKuQGR7YuUCMuqFtIoqybeKYXFeurWX6oR3+s13rD5iKcudi1Kgzuk5jDCsMh5mLRLgWn2vFfqDLW715AThZPDyEdMZ7Du6qVQ33AdrYK6qjD0MHuaT5jgVN/a0TZDwh2B7Lsn2Hz32P7P9mUuilHgSFAXS0O0YbP0Ute2F5LuGIe1cj7MxEhBnfb/uljAyec+yFQAzjJqiTI8XKOR9LYeggwljj2HiVeVtqvYqWY1eMWQbXaFjB0kkKao34q19BJpI+GZQpw73WkBR7XIcgfNNn7MKfvGXWuYUbg7StNf/TP+hHipD7x0HYRZEkY97vUWDeXbOSnAYtVmnymcTKJIGybRlJkkT7UYwWdqYXNl2nD5FvVAjG60ZavMV4Sg2nD+DsmIEWOSV8erKRr49A4FoJTMAi385hJD8XVNpPglIZqznyCXu9NDYmPlMbSl3sLvFNVlrkCqJHILIUzwkb6rkbaNaTbkpAalSpOwfL/tcHR38XWIHLdCoVTcjdU0CLe9u4W6LJEcigoKhCFOxFmmHKijiFRsSk9yuYTdcGrVU29pg333ci/tws9zASrePkJUabrpOxS9xHDgqQYdjtvWQe7okXeuO8V08VzzEX4Kk+c8NORMPJnk+725iF7Lnj2ikPWHBmcNV8MH++ZgK5qH4cI1p1KllTX2kvGzbv3XTDPev+OJndoebnrsclFoyrio6gGtMbx2DPMn98hGEZJdlpcSGxhR7EqD3VU7ICN3sXt8AVxQPbjNSbmG4f9h0V2ahYOL4m
 Cl5REcbT
 rXVxXSDN2pfHiOtbrzJ8H998de2yH3Paq179P9x47pVbLArK9r//eLnaBXU9cLb2Ebe6x6zW0V3/40M0aOmh30OjHlpUIVO1YnHIiqsvQOehs+zrrwT4rt/4Q8NA4ybpHEBPoGw56KGImKU5n1m+RW5AO4pcckQrPbFCc1hTNVkY86PPvH7UJ4SJ7GsacW20dtCdlK2cnrUgszXe/ddDzg+OA/gsI64CS0JWUh9gZmpLtik3c6SuvW9qymZi+Qi8YQ4yTgKwlXCLypqd8Nu79S+WP22rkh79B03BdBuqKG25Uk3fWjBx3IC4jiHmwSnXB+wN+caZsD1r3ksPr+WH2o01TbXPcVaOHR4Je8qbJn9zf4wwMU84+efEWn9IrFDIV0TEmpnuduhxPhBXFuF2EP1ng93eYW1tgSlz3iL5cG7hZbYgtrot2INrdVEQ2Kt0+ZcSfUPOHdtLDl45wUKIGUaltj5A/UxZxmui1yMUKpjR6qvJJ3JQayW99RClO3XKX9uZb63PJ739wMHO+VZ40hC8+W+fKrQKoEI6vJrJZlE3+b7gapLU9fItiKKkXkqMMzhE+TX0oMvy32t2VQeIUMgNLDsHXW0HyoV3g9dPRUadV8nLmlhl0bdJ4uQdYjiMcqyvjN5vl8/998JF76j9dFLyEOavVg/j/za0d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A later patch adds more code to the most nested block in
consume_stock() and refill_stock().

Let's reduce the nesting to make the later change cleaner.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 64 ++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8a401550dfaa..6666acc9cee8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2168,15 +2168,17 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages >= nr_pages) {
-			stock_pages -= nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (!stock_pages) {
-				WRITE_ONCE(stock->cached[i], NULL);
-				css_put(&memcg->css);
-			}
-			ret = true;
+		if (stock_pages < nr_pages)
+			break;
+
+		stock_pages -= nr_pages;
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		if (!stock_pages) {
+			WRITE_ONCE(stock->cached[i], NULL);
+			css_put(&memcg->css);
 		}
+
+		ret = true;
 		break;
 	}
 
@@ -2258,7 +2260,6 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
 	unsigned int stock_pages;
-	bool success = false;
 	int empty_slot = -1;
 	int i;
 
@@ -2287,32 +2288,35 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == stock->cached[i]) {
-			stock_pages = stock->nr_pages[i] + nr_pages;
-			if (stock_pages > MEMCG_STOCK_HIGH) {
-				memcg_uncharge(memcg,
-					       stock_pages - MEMCG_STOCK_LOW);
-				stock_pages = MEMCG_STOCK_LOW;
-			}
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			success = true;
-			break;
+
+		if (memcg != cached)
+			continue;
+
+		stock_pages = stock->nr_pages[i] + nr_pages;
+		if (stock_pages > MEMCG_STOCK_HIGH) {
+			memcg_uncharge(memcg,
+				       stock_pages - MEMCG_STOCK_LOW);
+			stock_pages = MEMCG_STOCK_LOW;
 		}
+
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+
+		local_unlock(&memcg_stock.lock);
+		return;
 	}
 
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = stock->drain_idx++;
-			if (stock->drain_idx == NR_MEMCG_STOCK)
-				stock->drain_idx = 0;
-			drain_stock(stock, i);
-		}
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], nr_pages);
+	i = empty_slot;
+	if (i == -1) {
+		i = stock->drain_idx++;
+		if (stock->drain_idx == NR_MEMCG_STOCK)
+			stock->drain_idx = 0;
+		drain_stock(stock, i);
 	}
 
+	css_get(&memcg->css);
+	WRITE_ONCE(stock->cached[i], memcg);
+	WRITE_ONCE(stock->nr_pages[i], nr_pages);
+
 	local_unlock(&memcg_stock.lock);
 }
 
-- 
2.56.0.317.g454f8302e1-goog


