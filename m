Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3CD5C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFAF6B0092; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D306B0093; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D6C6B0095; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B31D76B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A43212042E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:09 +0000 (UTC)
X-FDA: 84972726258.07.75E2A9F
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2D8361A0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=E4a+eJdR;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYm3HqIARDJIi8JhhkdB5U7wVUjxjYp7fxGMrzv9jKE=;
	b=pijnxZDSCKhvKVIcjc7m1xYyZr51o4DMq6WcGBrJqzQsHpD97ktz8OeombeP/ppV6ys1A7
	XNB9Oset7+xaUeh1sithD8rFmv8WjMA57KAGSj1hJfhz64Qo3mOeePk6RRuOY6K2uC4IYL
	Fm02T4WvQun4GFXI8HMdvmTRfuG41M4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=E4a+eJdR;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684867;
	b=Qh36BpEAxEYQikeymulxw8Q8r/ehm3H7QBKlrrfrN4mmccgrtYRDSL6Vl0W77da6GT4ynj
	/fUVQ+A0vInUHrG1ZGog7LZStwGUYwvrgj9s+jr7Xo5gIaksyMg8P5XhpxYNLGsWXtExBU
	7s2o/xRG4zrlbkwLMwwqokdzKEYV0eg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QYm3HqIARDJIi8JhhkdB5U7wVUjxjYp7fxGMrzv9jKE=;
	b=E4a+eJdRUtDydbsS1VnHQdvJSXtQ+HvU+seiSSzmi3ZLvbnqvkyXcA+o5/J++IIn4J3zxJPpT
	/ojIt9pFUvrWgX5UpcGIrOnN1ALzdWwVZX1VfXJqFj5CF0CpEqBeymtd6qI4IpD4E+nELX9+50J
	A7iqSAQC3JvAuAYZ3iMuHbs=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gxVZ03L4Pz12LFd;
	Fri, 10 Jul 2026 19:52:24 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A815203C1;
	Fri, 10 Jul 2026 20:01:02 +0800 (CST)
Received: from ubuntu (10.50.87.83) by dggpemf100008.china.huawei.com
 (7.185.36.138) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jul
 2026 20:01:01 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 5/5] mm: mincore: refactor mincore_page()
Date: Fri, 10 Jul 2026 20:00:51 +0800
Message-ID: <20260710120052.103886-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: rrhpu6mfj4oednqkjyzox68froumecsh
X-Rspamd-Queue-Id: 2D8361A0009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783684867-229402
X-HE-Meta: U2FsdGVkX19eS/ol1DuoSzJ+l1YeTySSSPCXGaT7vqoWt4No4neIB5xJg+3CwVDFHGQEGb27U6mDtGzxSxGTu/f68Vvg511qZMsfERJgG4VdwD6Qicgd9P4LUW4lVQU9vtXaVyCH2Ridwkt8Lnvhj/qfRvTQ3LzfDLwy6kur+cKVnmkhj6nAua30ymnaBgXhMyDxlg57Od6FMAczLge7YFMgrjFVVNZmQq9oAKF0ZtYBmLqpBExkHzrkDaK7TpN/FupxREovHUXH4Yy4OJsnQRgvCDaXW4E2F5BZBYx5sbVE1sHNks+mNBn4ekRL1dScVeuTWvtpdk33kt70RUDYRjeQMO/hCD9Z+ui1eKdB9hP9r9npZDrsoyCM00V7MWc92RO0mt7d/K2vvf3VAtrK23DfNMPANWS3qz5X57/zWi9W7WLKjkPHQ8jwpQRCmNgVEPi7mRgelGJ3o7apj2yRlsXfw+CCh5Zs8/CpQPITfqkDbPgE9AkDKt5voX+P2AIf2iUev0/9j8TmdpFeF92TNPAglqLbApq/Q+JZJZYBM+OwjKI0TmvNeisMjIA1/dYd1BUpTh+2DXTSdOfEl9ZuM99kEXU88Y8QQ5A4fFWBarV1hOcY6XSl1seqWuDvjp/oTvf4j83OnvVsNt1O5DjGasN9AYOibcjA07yhlS5tV27ZtJ+42ucmKPFo4dcJPzKFEWWkfhq4nbIm6chXSyb2iqLtGWhlolRVd/Mc5lVC0KC8Z4ui8gwyi+NIbVDMkRy6mRG2nTU5ZD4dQlXdEoFgcRTxLvnsqgggGaIOhSfA773PtwDxWo30VAdEsSRk9iYbBDkaL3WtyHYG20z+TJoN33YkXntlHBLA+sz6j8XGjB+GH6+MpDh6ZpXk6u9NPS9iryrhirE2kHUVwAp4qpJ3YJUdl/idG22Hrfgu9JRFOwC1MfcjOg1J6IT7qWKIdUqzcOftQwan5n1vEi/dKm6
 Q6kIK0Cf
 9fxmPXKg4//Pkvs9oX4PRkQu/UeCriyLE4jXDt+Q+H4RdjD+SHrixwQHpbKe6ly0uJ6NzvKhIfndEr2OSczLyNHZ+0loOS1TGYKwQlRe/LBoa5JTNs4OtcP3aIAjETlBNH3eGXUWRqiaiaguqRtRbrPp9nMtZIMTsbzDXADLvGz5wEKvxIN215GwkwISml3Yxvs1vRsbMEs81pQIJQee7MjS9xGYJJnwE6sJvmpy9UqFMCUFzK35ngj3RoDChiWVgW5qR4gDxw+uJxYApck1p90ub3cMY2hEEPKXMoVsQVByG4zPLoRJFRyzQTJbzoExp1OLb11i/EW154GSYPRtp+jcd/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use early returns to reduce indentation and improve readability.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 9952bc3edf76..30a3317082d1 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -94,7 +94,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
  */
 static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 {
-	unsigned char present = 0;
+	unsigned char present;
 	struct folio *folio;
 
 	/*
@@ -104,17 +104,16 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
 	folio = filemap_get_entry(mapping, index);
-	if (folio) {
-		if (xa_is_value(folio)) {
-			if (shmem_mapping(mapping))
-				return mincore_swap(radix_to_swp_entry(folio),
-						    true);
-			else
-				return 0;
-		}
-		present = folio_test_uptodate(folio);
-		folio_put(folio);
+	if (!folio)
+		return 0;
+
+	if (xa_is_value(folio)) {
+		if (!shmem_mapping(mapping))
+			return 0;
+		return mincore_swap(radix_to_swp_entry(folio), true);
 	}
+	present = folio_test_uptodate(folio);
+	folio_put(folio);
 
 	return present;
 }
-- 
2.55.0


