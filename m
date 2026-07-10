Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DCC6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BC16B008C; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233246B0096; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDA36B008C; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD6876B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47F1A1A040A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:09 +0000 (UTC)
X-FDA: 84972726258.22.0C24E97
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf25.hostedemail.com (Postfix) with ESMTP id EC5DEA0010
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=c6GlrsfC;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwC66inqird+vIj3akqBs97+/GB2RLnIcTSP0zo9jsM=;
	b=ROBjgcbGH6/o+PPoNshIgPQECx1Dc9fHYWKGfIjqV6sMWSLAqB8FvLh+Eg6mkkBVBHkfKi
	H9kAUoTgWPGutS5JMl+XfLPVNAeJ8GoAgCUf/BEqE+nTUtWAuny1TU5PbPTYzOGS0JTteH
	AShwMctGt1VPWW4NX4DGMJQ4UCEsviU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=c6GlrsfC;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684867;
	b=qKzv/1oU+X7dy5Q7DYL3KUoywbUziRamAfU01JgovhXMUw1HjBWtSOsodAhJqRgeHIsaY8
	zG6dsu8BdXlEGvy+5YInz1KSodDs6spmvX1ftNwLQv3oslTFFypC6Rou+WDZ1E6Y5u77a1
	5osTCNNHzznAlobMoif/PrCVLyG4GQ4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uwC66inqird+vIj3akqBs97+/GB2RLnIcTSP0zo9jsM=;
	b=c6GlrsfCSF9UReVabJqKRxSRAVPyKNvZKqpBBxd+Ly4WDmM+gmb8pJUYN5IEcpg2DI2futkt4
	gAun121dSJ9uU1DKwfHAqoo5l6ZC9zkG7Y5yU4lom0O/Tqd3JvjsDIp8yZ3jrR8GTU//fRG3ZC7
	uSK3sMctMEWDhzQBGPFxLi0=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gxVYs1RPxzpSvB;
	Fri, 10 Jul 2026 19:52:17 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 274724057F;
	Fri, 10 Jul 2026 20:01:01 +0800 (CST)
Received: from ubuntu (10.50.87.83) by dggpemf100008.china.huawei.com
 (7.185.36.138) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jul
 2026 20:01:00 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 3/5] mm: mincore: remove xa_is_value() in mincore_swap()
Date: Fri, 10 Jul 2026 20:00:49 +0800
Message-ID: <20260710120052.103886-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 4xhpg9r5sk9w6s81mxp5m9wd9hij6eti
X-Rspamd-Queue-Id: EC5DEA0010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783684866-50965
X-HE-Meta: U2FsdGVkX1/3vIF4bij8oEpZpjvfbF5ySNr1IBAizjX9i7s8OljyMHAN07TVoNfngndrU+1ih/YBAA+9iC6EkAfsWr1DIEopsvJr4P9RioeR5C/OHZzLYcNnuAVeAaFk0LUuaU+s62UnAVceiA0ARTAnTvUBEjpKy7GLEEg61KMAzDCCvYh/H929qfZnGVH47A+vht4OqbGK9vJEw/ExXuIscLL+wTIhcjDDo6rBxbe4kb7Zdw1ujA7DrJj9tYVo4yuGnHVF4Uf9K3y43amZLNOgMr+6cv+uxCt64qf1xV+iR93n3vI7iM2qsfE4UxcLsW3yrJQT5vqhSv0GyDzNguHJtdzG8yMz3a9HFe7GWJss6pPacTr1lNuJ6/IFNHQiEnlFqmgryIlFtIc16FiMoti0Y3IKmFD0F7q/avGcqNCsqysWuZQ7TVevrHglaKlJwCcaezw904KXBrHp9Zn9X0in8wsQU6M6kvewBxunM9Zfadpjv+I3vm1gYCaKI4496+iPntjNRAYA0wHGzWsxxYj8+ThCVa33r/uc+nXKCBkbmHXwwHz2Hl6X2oyVu4ClHkcTEvvnC7fCPR6rjldbI4m+ODGUpyql1N4v+wTo8YkxApDExSHcuF2D10a+bqFzoW/ZjKgDVxmRdleh5Ziv3CI1eO27uZxanOFDiHVeDdz38FdjXPVebwiq6J5HYRElVHG8fec6wUm1XsGSZZL1P+h5uj/8bY2Od3UBuw9nQLVwqy1g3pCHAvRSCJIjMBKY0cEeBUpN7nKzjkZWMEKLia6dIxw4U+ANsvsrPA/LQjcx6Z++0PVRgqTaQdvC8ezEnBg/Y8KCySB/ZtGQSaLDqpVuErqvvfTNtX0Al7SbqhczqZxYuaOrJiPUlmqcM8ho2AyRhQPOG/q5p8A9b7bpgJQxGFxqLH3dtay2XovSrnKjh51cdI4aZ0Gpcqo/BP2A8YGKRSkW/rYmtxTbiJv
 p0OSUBsq
 EyhXbCWNPxuL8QIu2oxv8zrPjCUjAuzEEF5jLJDw1f5WzJXOu7W2sBFZPFkEpThPQVw94M8df4HunMa8J4Ifc/bXL1xBeHWVT+6eeONmO+5yJiV3VQDzpbKcLKlGvNQqbizPNP00R5AOUOauTZDK1QF33w4JLRvJz2Np1yqKGmBPLSvyygaMNYIxsESS7nSYIznAwpzxNWzVmN+ApkbFxbujWBvT5srE5dTAlS/SjW8iQbN/xu3qey8cbO5TTEf+RRgC7sBz6wTb3UwQ5H+dFlunoA4os0qNLdr6DRDc9mxmA3utk9UWo49NrzzQsw7lKb+fgMMOM8xsWql7gWSZxg0ZGRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap_cache_get_folio() no longer returns shadow entries, so the
xa_is_value() check is unnecessary.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index bff19a0df9f5..8b5e6afefb91 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -91,8 +91,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	folio = swap_cache_get_folio(entry);
 	if (shmem)
 		put_swap_device(si);
-	/* The swap cache space contains either folio, shadow or NULL */
-	if (folio && !xa_is_value(folio)) {
+	if (folio) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
 	}
-- 
2.55.0


