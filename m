Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696D9606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HxtoOFve
Received: by kanga.kvack.org (Postfix)
	id 837156B05D5; Sat, 14 Nov 2026 15:08:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0E96B05D6; Sat, 14 Nov 2026 15:08:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688B56B05D7; Sat, 14 Nov 2026 15:08:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E54A6B05D5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:08:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6C684010D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:20 +0000 (UTC)
X-FDA: 85434811560.09.E48D7FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C83A1C0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxtoOFve;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dKIjKxFlwknpbWJVXX/cmtGsbGxhiJgbgpOqLZNO10=;
	b=XjeFK5Edfe+Ua6XVcZ3sIESYIAWJonBYQm0ZoGkPBC3owFj0lkMjHuF5FdoaNHiWCQeISM
	ondwUZGC/7BoskLe4jjYnXxTQpIY1aVDwt7/uKC5rf4lI2QP/GMMuIKtJJGeYExasdhtUm
	SWStm9PeovL6H3fKYAQOXDTjyfui+j8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686899;
	b=r7Dw7RNm7Zk+rZzWIdbGlB/yFF7F+flXNPwu5CwSdUQRwpF3cSyboWulj3XQ8GYqhF/KY9
	tvH00dA1mxodkQgfbysh9f76jqSI6IBguh94PQoYVB9J+QUDpFD9Yg/5ruzquqFt2udqQL
	kzUL7vOeeHSLnzGGMGrI5OQIaTJiPVQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxtoOFve;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DD5960DDF;
	Sat, 14 Nov 2026 20:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7721F000C6;
	Sat, 14 Nov 2026 20:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686898;
	bh=/dKIjKxFlwknpbWJVXX/cmtGsbGxhiJgbgpOqLZNO10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxtoOFve2T3VgwogTRiEZv3A4RdpF8863bbifdj51BC0LUnJhxcFyu6b8FUp9ehPS
	 13gdPW3bKoK3uPH0rqHF+OQlbpJ/tcMsXu+wBGzBwTmJsbfBnmGcOoUUTbIO2A1Qs2
	 +URqoL7N/Zsunypjrq6QxBhB1s5sNXfSNEPGT5Ke+b7EfddtEzs4C0+HJEL4n6uKGt
	 CEXXwPiR/LOiZHKLhVOyeXfTjzeJ+HIVEYsP4qR+hkMsb9Awa8HdPaOdXo1W4sTvkv
	 Gh8dH3is7b2QzKsg2AFRpYnCsmdke976eJ6ZVlTBGmUaRjEq2rWO+4BXZ3t7RnLlzz
	 fuxsKWJ/JdRPA==
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
Subject: [PATCH v9 01/16] mm/mglru: report evictable sizes per type
Date: Sun, 15 Nov 2026 04:07:48 +0800
Message-Id: <20261114200803.23129-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: pftjnddxrbdkawerf6316zjqbz33krab
X-Rspamd-Queue-Id: 2C83A1C0004
X-Rspam-User: 
X-HE-Tag: 1794686899-510214
X-HE-Meta: U2FsdGVkX1+lNW93hDPYaAvbmJt/54RaEHHjbFJow2QvUq8bROE+ONX9SxUpL6XYiGkInZwFtwLTQvcdwaS82GiA5c65M5Z/PYDZMJ6S6OV/XRG8k7UvgzdOcj4GlsVOptaABaf65RTmuzUbd4i747Qou/QAeHAgNvWvNTyjULDcovlN2r0pypTA7iIJLC7afD3D+6cVLLKjB+FUtzQNDCYQm5la206DSH3qOdLkxn/r0FfEOWcllYRDvVGb7Cw27F4i5NZCBP/ljGq+brX86rT4S+YVI7Nxds+xnolyO8AVdEjCr6lNzb2Ku/13cd0A4my1sYh6dvMNN+tiN2St1xSnQ9DJ16yee1L/t7AHRGGcweQtCug62UEOAdOX7krPjOEvsneXjq3xxCXHOy39hsOkSjt2byE2yOf5RUehAmMkFfDBXgbRhBetyjot5FMEkQNvo834NMCB5VdvhaT9UgndSQ1Jh0FnFEsZ28Zmg8KG4fLkSKMx6ZooiiJNBTvoXSdf0g/68/9mMcIZK1bks36/T9uG2a3oKYEJ4XMFQ1XiKv8S9ySvXWPTA5o4Rr/r5MOi/+curOfQTQ+kegL9fILgx1KhWMjFREIRwWkaOYw0o3ebC4h871mmfKtMZtPJVvWjnSySxKoLR/Hez3The9eU7xMz88509Hb7nUodQzRifDNTsgN7UZwUmHO9WKt4ENxOCVy+Cbo8XLOPe/6T+u8cYewWwv2IG007i/N654x8kWW6Wzpkv8LiyaiOz0kxUzTP16/b1j0X1W8XRBSfOLZ+fLnjqY1Iz2Ri8KVEZg+xNwOmW1sjYn5FGcC7ht8Z7ci+LffpB32lcp8sJx3gMea7MTSZmGW9NuyRMFp1qlXRGVJrZLulMaueM2SoKglu4Sjc8jxrD5CovCtbOnQZMp84o+YAu1ot+Y04nGc1JY6DgneCGVfoUwcqib9vpwA7xsedp/9wOjNnVO+qgeI
 fnIjmUmY
 4JHIKi+1attivwUH7OiNEoVZyezhaSDPSJTgpv2nHq0ohD7z3bO0dyhjhgi1m/fwPhyaLoUSJxIvdwfnJCTYdE6cdpgT8fp2vtTyQJr6WCwPJX7uh9VaHRC8/yT+gVNB0FQvu7pRuZ2qaTlKQy+PnrceStziUMhZA5gJkqnuY7GECEOYCSqOmUnprKIjEHsc+g01cF8uT8xRF8Uo8fWp/LP7rg6rUl8jqZ7LjqJwNLF14WTkIUVJjc0kgqxD/jcxXmDaC8P7SLMVz4JFxcoeLmnj9uZkzDSDUT5TZPKL6CEXckRDdbKXO6D2ASC2hOTvq4xr1NNj8NwhVXuNdHbYTlMMow007epxPN1DOMwVJvhjwWsMh0iD0kqKz48PNo5Dc3qiO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Change lruvec_evictable_size() to return the number of evictable
anonymous and file pages separately instead of a single total, so
that callers can weigh the two types independently.

Update lruvec_is_sizable() and get_nr_to_scan() accordingly; the
summed totals are unchanged, so there is no functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 46be9c7e967c..400f87fc51e1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4193,28 +4193,31 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
+static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
+				  unsigned long nr[])
 {
 	int type;
-	unsigned long seq, total = 0;
+	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
+	nr[LRU_GEN_ANON] = 0;
+	nr[LRU_GEN_FILE] = 0;
+
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			total += lruvec_gen_size(lrugen, type, seq);
+			nr[type] += lruvec_gen_size(lrugen, type, seq);
 	}
-
-	return total;
 }
 
 static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
-	unsigned long total;
+	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	total = lruvec_evictable_size(lruvec, swappiness);
+	lruvec_evictable_size(lruvec, swappiness, sizes);
+	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
 	return total >> sc->priority;
@@ -5028,7 +5031,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
-	unsigned long nr_to_scan, evictable;
+	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	/*
@@ -5044,7 +5047,8 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			return 0;
 	}
 
-	evictable = lruvec_evictable_size(lruvec, swappiness);
+	lruvec_evictable_size(lruvec, swappiness, sizes);
+	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
 	nr_to_scan >>= sc->priority;
-- 
2.39.3 (Apple Git-146)


