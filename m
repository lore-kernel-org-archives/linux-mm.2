Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E3F606D07B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mlaIq1/E
Received: by kanga.kvack.org (Postfix)
	id D215F6B05CF; Fri, 13 Nov 2026 13:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7986B05D1; Fri, 13 Nov 2026 13:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98C06B05D2; Fri, 13 Nov 2026 13:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93E696B05CF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4ED3EA7578
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:07 +0000 (UTC)
X-FDA: 85431003294.03.EFEAADE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9A92A000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mlaIq1/E";
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5wdJ/qn6omLpc5B3id98U2KGeiHvUPuFJZq033njYo=;
	b=nZIRO/KiEFQtyHUcATtVqG6gvYWNZDNwg/QvcQ3KZhcxdflHhmwJvr97S9eeIGrkqK3OgL
	sBI0lBI2K2xg6+4uDlSRdCtvUjpfUs7anrtwADXnNn30qLHDwBCxBdQewxCm0HDmnubq1W
	p+6ZbQ4InSf5u/+K0ipPCMc5NxqLomg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596225;
	b=hk9Nu1L7M4KO/2VFr1yHx1XZdeZ/EID94uNK9wNrx9icwJOJAMbboYqqhL+/rzRELtbjUY
	UHkUgaLMMbbuH7UVos/MQSzMg670I2ByfoBrENZSj3QZ5A5dshjiG9bQXy6NB2gYupxVkh
	JEuZZbc+B8F6i9bRgvm9GlRe+4qBlzc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mlaIq1/E";
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6019763295;
	Fri, 13 Nov 2026 18:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607D81F000C4;
	Fri, 13 Nov 2026 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596225;
	bh=O5wdJ/qn6omLpc5B3id98U2KGeiHvUPuFJZq033njYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlaIq1/ECiKhX1sgaJ79ZxG5rLmhWuUpdWnsIxSEPVAHzgIu4nlqCQt0YesH9VzSZ
	 T+XTRqak96Tb0ScKXzxRBJ6/ZXH6a1/OpQjyoHi1Cmpm77zKkAH5z0Rb0FNGIrABtz
	 f+5Gcaxd1Pl+QrdKE0MpaWZVUlpQQjB0+7ZlhfMhq5smacySYZfwt+FcpeV47GTFPt
	 oeZYePf1DDgU1v+4/ZfMpzAYnHCPveh7lSpNEb/Y+sf/aXfSmhGsrMFaWIO2PG7bFj
	 gm2Lo/jAf+txBPK0vXDqKCxSKNbr3HTK3kl9kIY3PxdDypWRRwOHiNaYVGjDg3iSTi
	 bhIWXzS3GkTLQ==
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v8 15/16] mm/mglru: Make swappiness=1 file reclaim more aggressive
Date: Sat, 14 Nov 2026 02:55:40 +0800
Message-Id: <20261113185541.70203-16-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ss95oo9u8umyrqdis81yk6ddiewjfm6z
X-Rspamd-Queue-Id: B9A92A000C
X-Rspam-User: 
X-HE-Tag: 1794596225-886714
X-HE-Meta: U2FsdGVkX18S70gMXB+B7DkN6Xzxy3JYS5h6N9uW027pzVvnDzKck94TVm2HAjm8uSft6TDVcw50pr5cyALyPeqjV0xXqz0H1929fT1vsFYjP17lhbs+H6gJVlLXRTBTzLl3k1dostGU2hYyeV5qQKvgquvxEAguOB0gzeb0jEeRhmXJNfvLFAg6REDt+RAwxEjmBBVJHQmsdp/SLATm+gGavBLacp9hMYrG2o8O1AcSiFPJ9FPNcDsGfLn2ltD+v7bpU5NLmrI3kyr/caCX/e44X+dlCtVFXVgUUR8hsKok+T1Dku3qEN46MEeu1zkuPJPBSkZ7M6h64SXiBHPG9BU+FmQVrhgFwKvps5VBkxwXpYsYuHqZMSeFcXFbPSQPocZPuaqnLMrHndilWcBXesmsZ0rd6qBvtixR1KYe4eF+4KbYttZR8GwRSf6xdj52CoUwzZYc3kqbvBk2Dh6XruGZiyJBJF/o+L2NotyFqsL4gKm75HbAoKbqL1w/vZeqvthR0zc1lNPbwVGQltbgDL0LPoT8zPpbUfhZAcInzGvLd8UAHIwUmim1UV595gMXzUrUGRaBL22Ce1PC4uOz36TnlyntCWA+/cC90n5bQnJx1M0EY6z9yX2uSHjqhC6QzUZkfHp9f60WVpiEokaRmBBS3rnuP1G3g8ttEScIYDblf2+6C3kH3eabHRr1deHqwwVojkNEyFmVZXrDer0eDbrjKHtqu9ndIUXq3KHpO08ODsr3J2a1s/u1bBPRNYnhWDExliQ6lFyO6x6FSvbWdj8Q2goP7dKlCJDsuvLYYSqhzAJD3aLl687zgoVYl70E23U5zCJ4WhPzGLYoCe1EQEJrQXbtnR7aTHTIWPu8BdSL7QX3P5JNz1MHP0boaHmUySXfx7ZJdsyoCPp+kgyPB0vm0WJfbfADwEMJptrj0BD3uHOVVjAlNyzYS5yCZdTaiRtPA3Eys8DwaLkHPGw
 +fEtXG4k
 enEIEjhTdGTaBd2s6nPbX767tEmkWrGde9dWcdhLQ4HoxPXFhh6/9lIaC6x6aMxzjuGc17G/LYWfFO9G0ktX75BOaYOv1pQ7iPob87rk1hFUh8hBJel2iFSV2gnYBtSTj3lrniS7q4srwzk89ic8A9Vb7M2tfNiCpgNJCBPE/fBPOZCxWVujoaHp43JpKrhpGtQFjIHq53CyER+nHmu08oqhZJ9iQp36XT77zV/TG0PTv/z9+dCjLeXoHy1JvnUPjcOQLlapv+hgqlVi8ROXUSJpxEhQHtot5V6ilHoUMrW/uwnbQGPtrAAK3yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In MGLRU, swappiness=200 favors anon reclaim, while swappiness=1
favors file reclaim. Swappiness=0 allows only file reclaim, while
swappiness=201 allows only anon reclaim. Thus, swappiness=1 and
swappiness=200 are counterparts for file and anon reclaim,
respectively.

Before this patchset, get_type_to_scan() always returned
LRU_GEN_ANON for swappiness=200 and LRU_GEN_FILE for swappiness=1.

For swappiness=200, file_factor is set to 0 at higher reclaim
priorities. Similarly, for swappiness=1, anon_factor is set to 0
at higher reclaim priorities. This makes the two settings behave
similarly, although the thresholds differ slightly based on
testing.

This allows file pages to be reclaimed more aggressively and
benefits workloads that prioritize file reclaim by using
swappiness=1.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b1a36dae6da6..9ebfa3e4eeb0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4956,7 +4956,11 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
-	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
+	if (swappiness == MIN_SWAPPINESS + 1)
+		anon_factor = sc->priority <= DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
+	else
+		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
 	if (swappiness == MAX_SWAPPINESS)
 		file_factor = sc->priority < DEF_PRIORITY / 2 ?
 			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
-- 
2.39.3 (Apple Git-146)


