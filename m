Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D94CD6E75
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 03:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65CA6B009E; Fri,  5 Jun 2026 23:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16A86B009F; Fri,  5 Jun 2026 23:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C726B00A0; Fri,  5 Jun 2026 23:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EBB76B009E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:51:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 572421639CF
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:51:07 +0000 (UTC)
X-FDA: 84848112174.25.43F73BB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6AD2480003
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:51:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fYObg5kP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tk0XIgTp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fYObg5kP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tk0XIgTp;
	spf=pass (imf30.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780717865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JS/GQ7OJ99Dui5f6CA/0f4Twxh8OjoBMiSDQYrLXiNk=;
	b=ajA5wI/oeChx78uUVQRfTyER/tR/zOdq6mYZFj+Y07kaAs1TYoR+WwA4XPc3jPTuTgBiLc
	l4hwaLkLm3FoRZ4oStcGInhL88E2KkQrHV6+uGjTDGWcCyOjre1nnPFKh9/DMG8hiViR43
	RNHJPN/GT8Re6sWHcjKmZk3DmvHf/ok=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fYObg5kP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tk0XIgTp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fYObg5kP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tk0XIgTp;
	spf=pass (imf30.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780717865;
	b=FdVq7KT4mDEU9uIi7gRtKF9UAtyIM/JL0C2RnOTAZ5maQEeU5PhBQWSD59T2jN2P6i4/WU
	C2FO1nzI1spw8NtRj05dmOzB4LIEP9NG/i07UxWN47RDhZxkCYsTKllT1+P6wrCJtZ20QE
	o3ghy/1vbc9Dlgpq5dImZkdtWpKoa9g=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E31AD6B373;
	Sat,  6 Jun 2026 03:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JS/GQ7OJ99Dui5f6CA/0f4Twxh8OjoBMiSDQYrLXiNk=;
	b=fYObg5kPurS2k6biMbbyvS/b1l+t44Ntr4dcNmPa5b6rJYeLwoqsaUxOq1MLLCB6dLlMlY
	TW7DspwwdjLIb8AiAzVVJk+tjORj1GKV5PSKcAEcjd39QDIxF0X9HTOywNiba04bqDPGe4
	y011mPjX+zBNrS4vpAIul64R/SdWIX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JS/GQ7OJ99Dui5f6CA/0f4Twxh8OjoBMiSDQYrLXiNk=;
	b=tk0XIgTpIELBeAbrbrj1ETIovpnJ7UC9+fHSjM86HxjmvfDc6MxBpSM1FLcNVdlK4R2NXK
	rte44tkobPjV4dBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JS/GQ7OJ99Dui5f6CA/0f4Twxh8OjoBMiSDQYrLXiNk=;
	b=fYObg5kPurS2k6biMbbyvS/b1l+t44Ntr4dcNmPa5b6rJYeLwoqsaUxOq1MLLCB6dLlMlY
	TW7DspwwdjLIb8AiAzVVJk+tjORj1GKV5PSKcAEcjd39QDIxF0X9HTOywNiba04bqDPGe4
	y011mPjX+zBNrS4vpAIul64R/SdWIX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JS/GQ7OJ99Dui5f6CA/0f4Twxh8OjoBMiSDQYrLXiNk=;
	b=tk0XIgTpIELBeAbrbrj1ETIovpnJ7UC9+fHSjM86HxjmvfDc6MxBpSM1FLcNVdlK4R2NXK
	rte44tkobPjV4dBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11486779A9;
	Sat,  6 Jun 2026 03:50:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YOR4ARCZI2poQwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sat, 06 Jun 2026 03:50:40 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Karsten Desler <kdesler@soohrt.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 8/8] mm,hugetlb: Kill huge_page_mask_align
Date: Sat,  6 Jun 2026 05:50:03 +0200
Message-ID: <20260606035003.529685-9-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260606035003.529685-1-osalvador@suse.de>
References: <20260606035003.529685-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6AD2480003
X-Stat-Signature: su8bckqf68nbhbamwa63sue11seoemc8
X-Rspam-User: 
X-HE-Tag: 1780717865-86014
X-HE-Meta: U2FsdGVkX1/B4kWsCKX2TnY+TH+XV31QJfmYiwMJf9Y0lVJQVwF56as5yi+aBnDh4O/mLAUsReseJHLP8pcxkyV4HJ4+IRnOrTiN2FQUgOEqdtLilkydENBfQ7uwiRx93BE/aamAVmE0zRsvWFKauZtYsCLcM7+wWFkPdlxfo6xbIPVlBUqxzoEEpDGdwWA1JafAiuie7HYrLwYC8VQoVGknEQVqL3RI+8uH4F7W79lXPPLhdaZ7/fhG/GjfFovQ5QvdTjKUe3EVW41cTkYepTz5PHYb8UYezpZegxzqvikwW6nTL/illMqsT8/RbffA9pBoiMS2yBa8mX7I8CVQPdaxEUwb/XLK1X71mlm3V6VSE6wh4lFB5ec+49NCV4G06ivfAHyqP3/4HeBTig/pO04IptDXdQyNu4xLy8eduX/5n9hXdldzgLQ+zKWgn1GTGgxA11kOD6KSaKee5pILh6BX0JBOzNhJ7d2zw8JWqF4jseWvKbsKhvPHVVIXtGLMQyTTJ0KUHCD88XjJ4D56/qLdmK9R31ljJjp7G6f9RL5P9ssSpmWFuX1dqgQS4cc1QRw1ws6mmXKGg5ZSAHedQKTyEfFaT1lse2jAtcDD47l+YWx0BDY1OBmVfATuqZRgi3EhRIW2s9BcbTyiCy5f/3+sPJX+QGcwPAXk8pTSWpSbqLuDUwovmw2Q7CO7WM+IT+RipQqwax8BYcrk8Yvo35VVG0G24aLzq+uuuWHujkTlYAjWwFDwxwpQPCJCQv+BYWku0aJUqzKIayy/bqJNFyfwqhlN+I/s9xmaATfOjKwke9YGxW1ZfhTd97tu236gkeqC2/8HUCXzPqE4HffwbWK4v4lVfllgLE6cu0YxS/AsKkdbmKUY8o9oFxs5hqoCljp17SYGv29+vDGIAdlqUn1VCI1eAZEApIrdoniLD11EvF12n642fTjgogbKLkKc1ogR3HulIhuH3uRcyqx
 +nLVJt7f
 fzlhgxRWh+VVmovv7SxgEBrBqTTmtKVVCPBi7m9IAze6moYfGyAYiOBGZzyBeD7lVqv7BQvXW5taTN3W1Q1TtNJxPaliz/xShxR0GatDd3aTrtNpEuiIblay0zVUdsksp55jnIzRO67y9EeB+etu4/Gv48uQp3lbHpCce1c2ubKWWe+QgFL+qoj8jooceiVpLwgmlg1MD0g10RL2LhSmHfsL0c4Zszy65S+jxOQDE5yQmz1amkDhp5SjYij9LZFe4qxzCmt7CrW9F0tw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no more users of huge_page_mask_align, so kill it.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 include/linux/hugetlb.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 924e9a464214..24e5079aa767 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1083,19 +1083,9 @@ void hugetlb_unregister_node(struct node *node);
  */
 bool is_raw_hwpoison_page_in_hugepage(struct page *page);
 
-static inline unsigned long huge_page_mask_align(struct file *file)
-{
-	return 0;
-}
-
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
-static inline unsigned long huge_page_mask_align(struct file *file)
-{
-	return 0;
-}
-
 static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
 {
 	return NULL;
-- 
2.35.3


