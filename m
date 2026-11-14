Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3EC606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KjcLnewf
Received: by kanga.kvack.org (Postfix)
	id 9E79B6B05F0; Sat, 14 Nov 2026 15:09:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998056B05F1; Sat, 14 Nov 2026 15:09:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887266B05F2; Sat, 14 Nov 2026 15:09:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1EB6B05F0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:09:33 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E808C1C3BE9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:32 +0000 (UTC)
X-FDA: 85434814584.11.F7EE904
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 56EC320003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KjcLnewf;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686971;
	b=L4IZ18e6wX7FWNr9sID7kbh7ilFL0x6h5Rg+T+fiGjSF47YVYtwOh345tfJPWbeOdy4qof
	cjTuj2eqMNlxc4sHi5B1eapmsdkv/0NbSGPqlLd8CSGL9b2lyqf0bfChNfO6ecFK/F9rRF
	lk/46V4imOXW/S7nyvfSgbwkHs19fqM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KjcLnewf;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+/Pt2UR788IAIB0+4Kh40rQr+T3EHhLM/rEL1xfbmY=;
	b=B6HmaepFPmi9KdslKkJH2bm6kfTdRxegWcTc0rZdwVbr/rJ2hxrHQ6bSfnIuinD+1cEdEK
	UqiLsWDhUuBCForUKRkujw0GJ6O9q3JFYIAl4atX4M6btJMaPr71GDErvPzSGoNE0BqxoB
	6dxM7DLWiXDpd3/ZS9C5zU5iWIsUhHY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A47044195E;
	Sat, 14 Nov 2026 20:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14DD1F000C8;
	Sat, 14 Nov 2026 20:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686970;
	bh=f+/Pt2UR788IAIB0+4Kh40rQr+T3EHhLM/rEL1xfbmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjcLnewf3E/ReLekwt4jGxQuU/Xj1ndY0CcmsbvL1K4ANPz1lI1J6A/aMfkZoUpfG
	 98zWl2mZwgO1DUFM4YQ4f44IQy5+YJSouJI03L56IvLPIu0UD6u0yY6n+CAHs7B0tx
	 Uhwe0WdXGZJDKw+WaoS6WDmzPriYX/mfiZJ+UajrqgMtjZn7b5Vf/GwWhUtl6QO83a
	 at0N9YigCtLaERy9Jf4vuc9QFWwtb2JF6wbMZT5DMA+tkeCz3e/t8qvJL/0COVDZpR
	 YvPqVS4xIxLGQg0zfgu1b7lAL7y1kAehTms+tsuXzY8/R+SFZopXUrJaqafs79gpsf
	 A1mijUuC2011w==
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
Subject: [PATCH v9 15/16] mm/mglru: Make swappiness=1 file reclaim more aggressive
Date: Sun, 15 Nov 2026 04:08:02 +0800
Message-Id: <20261114200803.23129-16-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: emzz13fnsg6pmcn35imqf58uk96fhtnr
X-Rspamd-Queue-Id: 56EC320003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686971-16165
X-HE-Meta: U2FsdGVkX18CahcfQYAB2u7N9wU3jGs9+KhSe96ChEekX0PN4kSYelyaEIrF3R7AccfCM1JoPzvoOxxQf6epq+Vby9HubvYAhNcGPewy3me1C+cyzOkt8YK7irWX5XoSnszo3F3DqcwoRaeJz9DYh9JQyBBCmY7yUQII+4mXAckWYJMTuPN9a9V1VQMUq59MS2SGeXNWjTdxqxQjcyILtrjfC+Nd3X4SpClhKH4+RgnahDe05xKeYb4n5qZbIY0+rHkVPv9Zin8C189hL00aZPnPqIsllpY9+jOXErRm0A7+sXJeZ8hIYywn7JUfzXpSLdyVcBnWFD4K5sa43UeSgHFj0U01YH2oOW7+TxSldYgeG665/G8CnZKQdpXhCqWRTVS8H/iOI9vM2bGKMffHAZ20+7JkYX5d6shaYMP7v0c/mNMGWCWaxqNvGKDTK+qjToLd/nRA32xM3OLp6TJY+OileR/7/Ct1bFs2F+sezUu6hGBvHRIGa/scXgKZ1EUqXwRaut8UyFuEZ88BlaWAqHdMlMFSq1m/OlUxWSCH1kvUlcTO5Y6pgktWgAbxX6Yrd7pcnkad+fT0mS+OznLY2E/xgfNZGRCtMgnhYMhEi91ns5TZ9VqanazaMgrh3Pe6eRxS0f4rjQQcK7R37UKh726UFJmrdz1UI22CVvCAk014XH/4rZMqBdLNaX3knTzXE71daTwUfoCjjolqz2fStqfdolKR2E7Q9Ia/Mc0kZTQeaOUaMTIx+lfJf405cevYQQXJB5s4TLnBduAoFscBqhKViF71JcrQiRMNeDWxIBlwiySjjp3p7fnr9GFDBb48x+mbr/SGycLwLVXlYk6fCCp+mf4y3ep1RC0eo/kjEG5WKr5Fr6nmTrCzXKUB+8vgWFWcpZFlsOFgdoTd9Gb82SExwJT/3+1WQP7LfnozGl9OIYp0fgfGy6jMG2ynetDqLfqC+LDvIqNfQu46NxE
 z9s8TQSy
 tedLPjmySUhb/+Gd6h/BDRXn6q5enAEYpQYriiQSzARADXryRnJ/lNQH8MIcee99pOa0Cgp/JSjiL3emcEt97i18qDbFTyQqDCig+U5+CgEEEvPlDgot9xhD8UvDNZnspzRfGBUtCXKBaZnjMLvvt9K+Ivj1ZenoR6pLg135UIIOqMweFv1TvMSsDarLpxH8PvYPN+Uxptkd/WVPyRuN0vw2R5jUxUp47fVIXD6Bj8VjKaby9GtGRYzXCW26o5xtef2a1Q03O752bHew4SxzEtLNWx4GAOZp9d3EPhylxKq7XyJ1Wtve+2D/6gA==
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
index abefd91f5b95..a9b97d23838b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4955,7 +4955,11 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
-	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
+	if (swappiness == MIN_SWAPPINESS + 1)
+		anon_factor = sc->priority <= AGING_PRIORITY ?
+			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
+	else
+		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
 	if (swappiness == MAX_SWAPPINESS)
 		file_factor = sc->priority < AGING_PRIORITY ?
 			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
-- 
2.39.3 (Apple Git-146)


