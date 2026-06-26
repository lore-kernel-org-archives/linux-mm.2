Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D44CDE010
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 05:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309726B00A5; Fri, 26 Jun 2026 01:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BADE6B00AB; Fri, 26 Jun 2026 01:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D21A6B00AD; Fri, 26 Jun 2026 01:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4D1A6B00A5
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:37:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D1971674AF
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:37:19 +0000 (UTC)
X-FDA: 84920955798.13.11977ED
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf01.hostedemail.com (Postfix) with ESMTP id 064354000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:37:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782452237;
	b=fhDfFm/vC85hfMEQEswcW3S7cs2s5OvTNvixqEZG3PlvMw618nXSSuBFXnY3gHelqmdwtq
	4AGFvY79IJh0ZoB6QWmXqffO9tgQZe1Y4WAOi9dM5MCTpSoHcG5UvO3GXZddG3dHmfAIWB
	IVP3KOl7nj5k2yWYi+3vPAwgNxDl7gY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782452237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=0fRac9g7xFADUxrUK1pW4Pv+lpPXqxRY96g6U1AVFd8=;
	b=VE0IGzsPHKVRb5xFAUPLLIvR1jprlKyHCog78pNOH8L9BSSGkB8vnISk6ZKmun+l6liMhO
	M6Hg8o6UDzJtDArw31MJsHmr6YWIg9G/V3h9mYEyfGvQJCYJn8yeejgclmCRQE31KGJ75V
	+Io/vuKbc409JQES3n7ki4ffQoq0LNA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn;
	dmarc=none
X-UUID: 115c4086712111f1aa26b74ffac11d73-20260626
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:91871d22-cfc6-436c-80ea-a21df0c3bb22,IP:20,
	URL:0,TC:0,Content:-25,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:-25
X-CID-INFO: VERSION:1.3.12,REQID:91871d22-cfc6-436c-80ea-a21df0c3bb22,IP:20,UR
	L:0,TC:0,Content:-25,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACT
	ION:release,TS:-25
X-CID-META: VersionHash:e7bac3a,CLOUDID:b5107a83e03fea0bca18c675b04aa7d6,BulkI
	D:260626133706V8VEZZ1C,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:1,IP:-2,URL:99|1,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,
	TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 115c4086712111f1aa26b74ffac11d73-20260626
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 206352148; Fri, 26 Jun 2026 13:37:06 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v3] mm: annotate data-race in cpu_needs_drain()
Date: Fri, 26 Jun 2026 13:37:00 +0800
Message-Id: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yp8jpjan6ki6hzo7tqes9wenc68i4mzi
X-Rspamd-Queue-Id: 064354000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782452235-272153
X-HE-Meta: U2FsdGVkX1/BC04m5i5gKg6KG0z6Z6FKk3AVxqGoNatQXTPg6mNrtH//tkqNLq86TK0IOq0z0ylVLePr53iCpVAsdxNScUBTDJrxV1Q4AkzyNfVayO7B6D7GjEmKksYpJtdu+hBp06FhGITEoOkQSoAHyUTTuwGnY4ecnrHgAuj6KYU6EH3KajAl3EHW3qR9ILfWzlOg5C6nqSZqwXVenlHtuwZ3Lr9hWAEaReyep8G6/Q4gDmJ1KW1ArjWSe/dkxSHeJ3fQat9FclYX7ntLeilK+6Zg8fzzEgXuJn0PVxlfRM8sE8OGt0lJVF8i1yMxiv9aBoPArIxOnbX/59hi/Oi3KdHnlLKkT1+j3m7N6e0qPs8iyXw7S89jBtYUsDKCsJcJ+bl4ExrcznXeEIXSBBpRJsPKP/Ct4SmguNs5aSzQAV2TxPQEj8Mq1ht+NRwDBHV5SOfzMYerJ9Hmwd7W8C3WW/+uF2k/y9hxr+ql2fq5alhIYFmOw9A1Exb+ZYv24f7QLdz8XPuNoGLOeFg3EQBQgBkJIioFShcdv1KiiaeA3ojibP+nP5KMwsS0BxLglCv5LZiW3vEGE0VE/Il5YDsXNqYiHdwarot5LFs/JTheTwwxKTGBvXfwA9jOQ33s7hGq8e0zw29VbU/Lt19vhkbSauA5hsMd90txJKkyLhKy0gEQZE/iF63uTsgKE0hC4VtfLHXHHQTzpXwDyA8kNqx3xU4lFApn5z9+z3RBlq5qRBvRnw8a0fm8S9rWXb69lYtQqSmj0oumFKSPpJiyoLkJNxD00Cj5HFTgCkEx6ZIvTGNTYjDj1hz02HW3NLISobi4O0Kyu4oDR2a3xzgXFsVZi+w+lbe5kODDXcnKm/UdvTIgfK+lq0L77ORc+vZJJpZ7KGua5LEsEgK3iiaKHHI9vKsT4OUmST2405nGriXVWql4Xnv6njHhouMYtJsHoUvpYkLQwCYuvg3GdbR
 M/U6XEks
 TdG6HKOSruFE2O2YViaCVLt8kGq0I6jmrtsChhlRv+D56iSqscsTdv1IJE8b+G7xxOIiQscGugUfTH7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KCSAN reports a data-race when cpu_needs_drain() reads another CPU's
per-cpu folio_batch->nr without locking, while the owning CPU writes
to it via folio_batch_add().

Reading a slightly stale value is harmless -- cpu_needs_drain() only
decides whether to schedule a drain, and the next iteration of
__lru_add_drain_all() will re-check. Use data_race() to annotate
the intentional race.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
Changes in v3:
- Wrap the entire || expression in a single data_race() instead of wrapping
  each folio_batch_count() call individually, as suggested by Pedro and Lorenzo.
  This is equally effective and more readable.
- Remove data_race() from need_mlock_drain(), as it is now covered by the data_race()
  in cpu_needs_drain().
v2:
  https://lore.kernel.org/all/20260625065153.1581419-1-wangxuewen@kylinos.cn/
v1:
  https://lore.kernel.org/all/20260624092606.1083449-1-wangxuewen@kylinos.cn/
---
 mm/swap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..46ea207e0624 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
 	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
 
 	/* Check these in order of likelihood that they're not zero */
-	return folio_batch_count(&fbatches->lru_add) ||
+	return data_race(folio_batch_count(&fbatches->lru_add) ||
 		folio_batch_count(&fbatches->lru_move_tail) ||
 		folio_batch_count(&fbatches->lru_deactivate_file) ||
 		folio_batch_count(&fbatches->lru_deactivate) ||
 		folio_batch_count(&fbatches->lru_lazyfree) ||
 		folio_batch_count(&fbatches->lru_activate) ||
-		need_mlock_drain(cpu) ||
+		need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
 
-- 
2.25.1


