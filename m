Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86301C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742B96B0112; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F30C6B0111; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4466B010A; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 011156B010F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E81A403AE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:38 +0000 (UTC)
X-FDA: 85092520716.02.38E367C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 07D43100005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JdxppSf9;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWQXEeuSvxK5SjOlteLHcHA1IM+jE7w1Hqw3xSPnRB8=;
	b=D1iRpk9StYb67Du/M+R1M1HiVPDTwfyyOO60NDZjHs7LCDOn7zr32fO48iCNFiUznJZPLp
	o2RPfdKw6yxxX5rZ04IWnIv9cGuS5PQQ2ka+dOS0L8lKm/qemL2OzyITBMFjMXEPSFneR5
	g+sJ83fPckW+0UShu0uhtvG3NMPDo1s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537117;
	b=TVr+MRYoVycSlgGz6vup3LafzR6yuOQ5+AtHmnkhYHnX/EeEK9xiih7G97qEJZQz4Vf2J/
	yajwDq/3jYKAjRclxFaYFA5YVn5DokZuF3MINskPPBjjiMx2vM3QjZIy6pZiPhkhqaLK2L
	quWa1KPkjURO5JWSR2om8H4ehncFq2g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JdxppSf9;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89F3C61878;
	Wed, 12 Aug 2026 12:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBE71F00A3D;
	Wed, 12 Aug 2026 12:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537116;
	bh=LWQXEeuSvxK5SjOlteLHcHA1IM+jE7w1Hqw3xSPnRB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JdxppSf94PuOpF0SADdQMVWKqkvDo+ItECrjI0+o4AY68ly6P/63VQSpV9X1KgGvN
	 WLuQ8gsxYp4Ngn2vqpqZ1K1tfeslEpCisrI8jcqa7HKPK1lT1stozgK6kIHf0FbywM
	 cxfjEiWnER0RFxYX8Lt5WcfX5410UHVstMh5YMZTBwunWRre6eisUZfCHh4UeVawua
	 RJga6ONZ3Ezai3ZWO8u2ezQw4XdrGTVtQKrjHJj7rZDHnxVuY9KQ0fQ3LF4VjxJAc5
	 f28gSROyPaRzuegmbNo0x1tPvmYc4CHjDJfv4nYfDjr6Shy4V+dk1pCv/GMuqpaJO6
	 EB4ah+nlQkUqA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 08/16] mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
Date: Wed, 12 Aug 2026 20:16:50 +0800
Message-Id: <20260812121658.69965-9-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n5fyxh53m4jaky3fn15bw5xj35zo5dpk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 07D43100005
X-HE-Tag: 1786537116-312232
X-HE-Meta: U2FsdGVkX19Rv+aqnNuDjwi9eHqTIImv9zJ52ZDsPGr9ScSSMdJmWl+49IW/noIlWUfPkv4R4wtOsYM94DafxhS3yRWoyi/EHrzR0elyH2oBbmx7ZnCQxJrjh4L+9l1uXIfsgblJq1gI790Kaxl9euaNwVVcz9G/bvVTzqnJ08ctzAHbgP+ivRhEccKbLNQsUVpeUCMsja6ZOITGG0KwkbGAjxjg2ucnAtI4sRAOrC7AD0PzTeA/sxErkYONhEORPXBh1a8OSiR3UGryQnIzuOOfmD899wmZ0JWuL3zxrvMH5W1AXX0vsG9K6b51i72WMBzkFbiM5LIsGJzRwGykblFdNP9T+UEoH0lELnJfhFs2un3xfcxFRV2QfIXN+lafokWuGwk79utV91ssE9Wemlk1xKVtcXZsZ6Lfp9sSNuGP3QF+1f0e/R04xXw8+fBQvfCk3J3XjgTcSIJNforMRG5EA8DqnA9XI6Jbji1H7WVqNiHCo16WmQuf3s7qn9YecIN+pwJOby/xKRXvohfs8b4HHcA9edg19IscdDwYOyW2HeGM6ROctHPiH1+YNKC2qezyCf/MjNsnhxLvMlkaks7x3+yZCloMTFT29Z0T/x3/jktrhu7sP2VELQSM1fRFD2EeOeMnJyOB0QHovngjVlux+6yX/3iEwp4IqntgFXNquU6LACXzU4L+wsZbB8+mh8UhobcdCTSzzAISV9E9iJWLiwMAJRBE3oZwbgZViD6kLhli3qy2iU8117qfoEtpUCJUUl8945DLVIqXeF/XnEA0YLaNSYilBwlHDmTbTb0d+8mNpMRlc1jvDso94YYOI0mMKSKuwx2dKLvschVnl+nu71jNOyDOoYhcop5aU2t6OKl+SFuqQBuI70U8svxmyFDsYobWhKW4+PkI6FtfqGTH2qlA3Au0UP5YWz4YFURP5SdGJBnXd8L1ey3sIwowhXGjjslAbnXDYpymBPX
 AOJyV4s/
 rwbs0n/GZGrFwmIO2vMHd9W2hI+ZID9Yx5F5W7ccrPjia0c6eNF8lzeYyM02sxowwdjtSUvSKAe+bO88QpUYRcTa2BnGTgLMbmJm6zp/ZCqG4HhkvEMSjQh8HWFyggCXHcZz/FpqYUX4SslM4M7maqkxGoTaxZQq5mXjViochgXEIyyJx6PWtwyf54rYQuMltdKTn8POE/vwuyU9hzoTzfT2fC3MQVYrkvNpbTFK8R7Ud2J8stlfPSOPWDL2ATsk6qAFKKkA8rl02XUAqyNpAL46C8SFSS/tZe9Lr5gUGr6Dxp3SVT5NOJxQVNxuF+RvEP8Gbo0F0Ivy5xUa7khD73v80bVq3YqnPBnO2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some folios may have been promoted during aging, so don't count them
as protected, similar to sort_folio().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e0625e6ec919..27623d3bad95 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3948,16 +3948,15 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			if (gen_increased) {
 				delta += nr_pages;
 				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+				/* don't count the workingset being lazily promoted */
+				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
+					int tier = lru_tier_from_refs(refs, workingset);
+
+					protected[tier] += nr_pages;
+				}
 			} else {
 				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 			}
-			/* don't count the workingset being lazily promoted */
-			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
-				int tier = lru_tier_from_refs(refs, workingset);
-
-				protected[tier] += nr_pages;
-			}
-
 			if (!--remaining)
 				break;
 		}
-- 
2.34.1


