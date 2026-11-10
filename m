Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7528A60A6F7E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzJ5L0xf
Received: by kanga.kvack.org (Postfix)
	id 8F4AD6B05B4; Tue, 10 Nov 2026 15:20:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CCCD6B05B5; Tue, 10 Nov 2026 15:20:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC1B6B05B6; Tue, 10 Nov 2026 15:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4F76B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:20:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52269160A99
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:48 +0000 (UTC)
X-FDA: 85420327776.27.FC78BCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id BB84D1C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzJ5L0xf;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342046;
	b=e7uQyLQer+M0lE0DEtaWEGytFmV/X/QtxKqhJh1hUwMVACSfrXMLB4T20vli8MYdeDkRzo
	0fQpcATi+9WHJOZs4XOwDOOb+QCfbqCCBHcEWOCFa8jqlaKlIS7RPO/x8Wa4ONn6iq92TH
	p3Ilts+jfpoaCaxH7dRPAsg8QCMyB7s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzJ5L0xf;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swxfRysumHKmdMmk09THVTvxU/XqkcT5rR3pmvabELc=;
	b=TZYwJfo9njzv8XFKNWrqv3coQ3nTyW5EsrV2eVFuJ3EgNXyQnAb0KRUISd3oB9Y9VAAA1i
	PquNK2TckmvD4zG71DhjlzVqjbkwd7zb0Nj6NYubnqS8OMXIHq8P9fbbZwmfywa6GBT7pY
	bXAcFX83edC+S5RrgRfJCs7ZUcBl6/U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B6DF634AC;
	Tue, 10 Nov 2026 20:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2771F00902;
	Tue, 10 Nov 2026 20:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342045;
	bh=swxfRysumHKmdMmk09THVTvxU/XqkcT5rR3pmvabELc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzJ5L0xf3Xola7GZGpU9ZPgjlw/jA9OU75CboafEf0+1r8BIgz1X83g5gWkzhb336
	 rFtcYxYzIO0D/cZkSNookZ1Vg93wEGs5+Vnub7RzSpPZASRKeqR164NakAGZ0AxXAg
	 qV/r/Pal45z89NHrrGFm5UrkD5gORPkjIdPaXVbk9OY78qizzVBU8vW8C/reqOa54w
	 liR5fLibokHg9WzNjprd11XfezWAI0izO7OetM+G8Kp6o4eBTDDVVBNtLQKy8jN5mk
	 jEA6Bp2niQYfuRKdqEA7UqXCBzJdNGARWM80kO1r+oFkY1VwclTQRjxFD9kRITqWV7
	 xUj/BoeYmhrEA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v6 02/15] mm/mglru: extract lruvec_populated_min_seq() helper
Date: Wed, 11 Nov 2026 04:20:12 +0800
Message-Id: <20261110202025.25736-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cxnz7pbtowhcmcuf4edrtmfwwgs7sc39
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB84D1C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342046-871716
X-HE-Meta: U2FsdGVkX1/Uc4nBEMiaToDHCwmd4VuPGCNMH0/5QCCxJFDdKqdVwp+kwTLpGXVP020TUI0rsQ3ZIDJhVCmP8tQdp/dUy5xfjQ5m/y7kfq9HWHPp3WF1qUCldz97tAsS7Yda3cUwBTyrw6HNmjB3UGHxIxINnRMRkeyLL1HVdgIw210WCKrjWl/svJSW+MjwYOb0egn5CFhAEO6K8cH0MEuKWCfRHOPey62fdy1PeVzriz3g1qTPvbOr9KwvxpZ/P1QIxMF0kE1j76/zaCxWji43pRdlKL4Ms/NPP2ZTLqZBARayXhLyJHWqdt074GiOMwBCQQjuw7qaeKzER523SDUFR0MbJbKM1sdM+3GasBqeNjkXHS4D1DqbJ/5DWKU0SzgziZh8CydaMiy0je9GbXmhgE4mzzyBquqJydOTtlo1OcYafNmjZJ54zn7rJVR1BPp9j4Lq664i2NjEyhOGBcpPs5GDaN9quUDIphnJtU4aevcbkB414YLe09sKnnq5Ag9qObGohEi1wAWcZ7Gzl3INt3C15v8vemCcfjuVanEWD2Nnwre1I8MaTrihsUcuTMSAt9zH3O9o5/uE2TeSU9SiFPJFWHQb6AKPuh93JTyfoUnENzTEe0O8nW4mM6FTF8fsiOONP7vSeIPdPP1ZCAR60kYyEO51DwCY8gdR3J8RTd00a4F1KGrszipLYPaQcuneWN8b2ygcMlVytt81N+kaYGeplaUZYvzYxoydK0NWpAbOYiZHbLJSjG5vA9wSp4x2pq1EJ8C0miqvBom8Y4rhLNuqZBPTMv8+hN8Dx+MlK2vJYwg//boKRo+j/dO8KLgbzTlGquIsB4UFtGQvHLNJQ7cgWu8VUxck0qX8Y/yGW/U+KwMSpCqUXDbFg5dNm0gzw8p08GLUqpVyjOtLGqZK/BA73OM3oTjOoLUC57JOjFWfBqLtI6XKcBriX+JOYVBL+7/RFXZwNkVynSj
 8JAlC0A9
 C+08N643Eu3CkYE9amkdwIbdmKkCppqO2dAE7BLyUHqFe6vF4kzvlJOwZIZto/qeIfhO5MOqBRJBwU3XoEmAzIrMC5azmhf+2s6kWPE5MX4Izv1exqI2TDSCthmEuthrXmINlYvGi73r1nOWqF0GPL9labdrHhmP+1XqxOmPsXiywd9RwMJrfsol+zwLyzi340YixM9SvQxSSyfbItB83lylZVDXF2vOgCNwWsXFnf/pzZZkiGYz7FCofM/I6CHdV8M0zkgsFoOREVxvWq8O5Tco2e7ia07xCXwGtJf8CcWDRf8nNBjrqr5kjfFJX1QTCdEBlnveguIaaYyEyWdbRqdvs5jv1qsDA7fxTSzTHaLuBix3z5Kg6NEsKCKjIFHf1WRYryB4WVHfLAwtEDdCCrfhujA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The search for the oldest populated generation of a type, previously
embedded in try_to_inc_min_seq(), is extracted into the new
lruvec_populated_min_seq() helper. It returns the oldest populated seq
of a given type, bounded by the given max_seq so the search never goes
beyond it.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index acc4efccda2f..4ac80968e634 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3991,30 +3991,45 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	return true;
 }
 
+/* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
+static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
+					      unsigned long max_seq)
+{
+	int gen, zone;
+	unsigned long min_seq;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+
+	lockdep_assert_held(&lruvec->lru_lock);
+
+	min_seq = READ_ONCE(lrugen->min_seq[type]);
+	while (min_seq <= max_seq) {
+		gen = lru_gen_from_seq(min_seq);
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			if (!list_empty(&lrugen->folios[gen][type][zone]))
+				return min_seq;
+		}
+		min_seq++;
+	}
+
+	return max_seq;
+}
+
 static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int type;
 	bool seq_inc_flag = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
+	unsigned long seq;
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
-	/* find the oldest populated generation */
+	/* Requires at least MIN_NR_GENS gens for basic functionality */
+	seq = lrugen->max_seq - MIN_NR_GENS;
 	for_each_evictable_type(type, swappiness) {
-		while (min_seq[type] + MIN_NR_GENS <= lrugen->max_seq) {
-			gen = lru_gen_from_seq(min_seq[type]);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-				if (!list_empty(&lrugen->folios[gen][type][zone]))
-					goto next;
-			}
-
-			min_seq[type]++;
+		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
+		if (min_seq[type] > lrugen->min_seq[type])
 			seq_inc_flag = true;
-		}
-next:
-		;
 	}
 
 	/*
-- 
2.34.1


