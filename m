Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85DFC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB176B00B0; Tue, 30 Jun 2026 15:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216376B00B1; Tue, 30 Jun 2026 15:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F596B00B2; Tue, 30 Jun 2026 15:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C610E6B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 555391A0590
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:03 +0000 (UTC)
X-FDA: 84937516566.18.622852C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id D0799140007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mLgJNmEv;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846541;
	b=Qcfwan/RzQ+v8O+J4jB/AiQx2JJWRgWPIa8NZZb3i5kiY3RDvmeq81l1UG70vJzzinS8fF
	9agZ1J3LlXmQ7VZTZzw59BHDS/kSIv36/Nf41HlaTXdDfCaJGxxGPW4V+JPpwlDiSsrMk0
	AVRmKBxhnjEsTlQbEMKLaUyrzyKzh2s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SaCCV+dgExZpfO0qJi5+zeYIF5zjkoqAVlfeRpmiOI=;
	b=jz0HpCQwu1dNUck/w5sN9j7b7BnS4VIxCFUfD9JE417FGAjHwQ+i9MqZqEnQerB4pYVF2B
	O/H9BT8sZzzmZAqyEyV+efrM7t1cHVQD4tGx9KjmFc53jGj/4HxoVJfkHibuEP2F9BWVUu
	U418c1LgyUptgfmmF38I66END1VK+KI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mLgJNmEv;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5SaCCV+dgExZpfO0qJi5+zeYIF5zjkoqAVlfeRpmiOI=; b=mLgJNmEvLgG2fcwa1fP2VOdrMD
	hBUZQOig9vM+gxgxYfGCuFs9iQev/WsowAS8+ZUz7noeN2cj02pxeVMFgVfy5mJWDsK8gPdHDOwwS
	KQYPR7Oj/UvAGaeDcpMgxzHno3nb0SadzCBG4vQb1LHXt5PJfkODow+LKKR/au4a/TbTkjF0Phd6H
	tqqcuMS7k2lMFw4bW6Z6s4YpXDR1Fo/BneRPYkOza9zQNwxzKti3sNdMCDv7OC3htqIRFmUjO+lCb
	avWEqyCfhVbRLdjtKilaeIqlP8KMskQYNoThHW/PBYO3ioki+gvOfMJsDi9+po012pKKKiC6YXgTM
	ZnsuyCHw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpM-000000005ti-1yeX;
	Tue, 30 Jun 2026 19:09:01 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 08/19] maple_tree: Use prefetched value in mas_wr_store_type()
Date: Tue, 30 Jun 2026 15:08:32 -0400
Message-ID: <20260630190843.3563858-9-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: or53yui5xxkmdia3r1hsfac63rkk7ixf
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0799140007
X-HE-Tag: 1782846541-549201
X-HE-Meta: U2FsdGVkX190emJ7oVvmrOi8Kzij40RSRVxNR40qBWfwiMGW2ro/HVa21zRvSwCG92stHGcUHPwS2/oYtTaIEXEdhH3Es8ghii+svCYHnVZLDXZXacvJjd4JJ0++B3BgPBBlC1AZq3CiI/KJ8xi/mY2JfqwyMtNXYI1TN93eIuiCfY1yS9pg+WVewjCSel5U4LghjBbHgpjdOhI9O6FZps8lidhGeXvSZVD8x5gaZC7IUs0y23CGkfuOFvUCiqWDUbe7XdkPG9msYT/ywNCpJB3qLQTpKCtio7F/nlacJM8b8QtcsBICLJ/vPbUaLqG7mfelzPYQYSgR2k6QU0tj8Xsfff1Z7/5tf5s3CAu0ffm6LpBvwGwbVCCkJ6XT8KNEZzsqnR5zfrMM+vSBNH0XTztF4uMlAe9zsjJyokZxAqBa87MV2eWJTmpPtd+Bcl89rNYlfgH7CUnxbZes5yPtjt5eQ/6ACXOhoYoFTVvrP+pUtUa3+pIde0pjaGSg72XrhsW3lrSiOg8dX6Nx/Fe3f0tcFA69gtfPV3D5szrl/Nn9sOJfcmyQVT9KI8GWGYziQiAfMx5g1VNiLK9ITr8PdheywF6NupHh/Yn7yDg9WgaBRvQ0ixxiQTfMMu7mPjwyaIcGCBHfDMFOP+fpagP2++K8+iXUMFnWmVsvzY4z1V3PmyH+vczAJ2NV8fB09HlHZykDdF9BG4YudPNg2sTcguC7UtzvoGmc9GjN/kJVWglfi7N8XUu1dy4XD009A1BhlAahmX+FKr9tizu2ii3X5E2SieeHIRfOYCT8gZ8mkiTwg0WKGTb9sFWRJC8i7RFZwH8Ia64lh+Tf+iG8eD1tKGZmUl1zu+7/O8uC/49CAWV8Nin9H30N885dGTJ0aPOeijyKAu7b+ctO9UhDJlltRZrn2P1Z1UPitk8YHCaDTbRDR8Ycsy5o+ng6qOsKtZX/UnwBbwp3lxk0uo8OaoJ
 zHBi5jcX
 ZSBgHy7hHkN7uaSouzucT+I0uNn30fLTaXYmgxRUeKUmTE2zQMY3LCv+djulNrA+V+4Zx98a4vIHhPFKKoy9Fq+LLUCnUW6d/RLlCsBVaQQ8SsQ4Tx5fnq04gX2jZILyvRIOU33vy+KDYNkF/waYaSvvmJyWf7/7DcA/vb55idaxDsrpiKUXFsrD3Y8iZJxcJxv45OHOdpQ0zLezgyZPnkc6AAOpjN6BBVY34qpIrDOCmgJpTVwlSMv3s8Rn+2KqikORdyoMF3ySLl8ySOREyylfiVAp6cAwpKG8Dhlzn2qhQYo5C70hV25wBhQrhaRaMI8kzebGUuj4XJCBR/AbB80BGAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The slot contents exist in wr_mas->content, which has less overhead than
reading the slot again.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 3886b856d6e3a..8f5a7fa10cf4c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3279,7 +3279,7 @@ static inline void mas_wr_slot_store(struct ma_wr_state *wr_mas)
 	void __rcu **slots = wr_mas->slots;
 	bool gap = false;
 
-	gap |= !mt_slot_locked(mas->tree, slots, offset);
+	gap |= !wr_mas->content;
 	gap |= !mt_slot_locked(mas->tree, slots, offset + 1);
 
 	if (wr_mas->offset_end - offset == 1) {
-- 
2.47.3


