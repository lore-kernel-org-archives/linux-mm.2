Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06781C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0135F6B0098; Mon, 29 Jun 2026 11:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF9B6B011D; Mon, 29 Jun 2026 11:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDED6B0126; Mon, 29 Jun 2026 11:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5FD46B0098
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:22:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24EB61201BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:22:44 +0000 (UTC)
X-FDA: 84933317448.16.A9E3173
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 433EC1A000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:22:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kDKQBArW;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782746562;
	b=U74HCX73CyIp7zro+L+uDd1/MW6EsBlDUSjY8X7js174E8oESK4oCvebaJ2lbT8EakYhXY
	txrv7WVJyY0erO5rIeW+d298ZeobZcKJ1NPtxlR6KNPfyLp1QdduelF/WEebnHKKJ+o6Mv
	dIEwzIyd9E9UyP9XOP/z41bVdiXeB5g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782746562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M6iR2qrUY3lKFFhhpreIimEDASDPW2AVk/qsJWmgcHE=;
	b=g3rgmVYd76eGQze3h29XmUo2CTw9o2Y/AJzOM2fdtXt70Nn/+sJho017qejeWHanbrseKk
	6Wbb4GFNtIRj7Q5F9u2pLxhZbVNBpIeiDFwDirUC0cF7YkVLxkZmKVrFFMwiCD2Dw3K1wU
	AhuyT0yx9UVLdi9EeQIGfcusoKgSj3E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kDKQBArW;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=M6iR2qrUY3lKFFhhpreIimEDASDPW2AVk/qsJWmgcHE=; b=kDKQBArWTBErvdn6lVZwgItM6J
	G62SHu1j97tzY7OXR5LFx4MmbnL2gsqM5Njes4h0SW7M8IWkMrkkPUIyoDi7mqjb//Nm6jAIfZ8D3
	+ig1qjM8e3wnm7TxtNlfulp8JkYJByfdBAEqPZ/JqTjnpYUs0BR2L8ih0EeRtagAuNrmwvEWsCMmj
	3yr15qtUY0fy5IwPwIqtnGpycII9+iZHdYy1veJT4b+uYJ/DHC0Ec0/Z1wVEMg+WY/21NbPwTsBUR
	lTT8NJ75xywbeFcS+KL1Au09zxnfXeTFB0vfi4Z7KEYC4gVgh2xcJIvUvt1+a6LyLbqJDtQV7QGAc
	eMKcOrdw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDon-0000000F3JA-12k6;
	Mon, 29 Jun 2026 15:22:41 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH fixup] maple_tree: Fix dereference of rcu type
Date: Mon, 29 Jun 2026 11:22:35 -0400
Message-ID: <20260629152235.1629785-1-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-12-liam@infradead.org>
References: <20260629144145.1572283-12-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 433EC1A000E
X-Rspam-User: 
X-Stat-Signature: yoz9eiya3qfmym9y5mpo8t6am1cqwjde
X-HE-Tag: 1782746562-779423
X-HE-Meta: U2FsdGVkX1/4CK2UmozFAJZG+0gjNVtIgsgeQfuXjS5gisw5kFt9lIvPISNKX8EPqsYt9eGVL2agmknC3EfhQyas2Sfh5CdD1BOnJZQVngsRVwQ57PAQtIvxPt5Wsnr0Xd6qYRESd+sDjOTqz/86Ob9tX+Z50ad9A+8FWFbhJIhA4AZ3sRzP3AtAC/Ml70y5dcy+31V1d5NG8UXMx+lZNN4mIuZuFOmFGGMOBgS6rPTi1PYVneTksq35/Gx6lKkSpVS0e6rCsYCI7Wy+zd0/Lb/85+R9rL9v785of66lwA6iLHVq2IFeDrYcCdz34h6vAfwJ5uwha+wn34+x5a1xngBx+AKjPA29lGK+XFhsq6a+bBon40mOYaseGUg0mQKgD+s+0fBK/eIwXCkaXtKHFSsw4NlO7Zf7wAHdfGawYgOrHQwLAJAV7kE2OBBXxK0ui2XrxAwDoRU8uk8AyQxd2kEiJ88FrqbbSB9zfZ5S+r2X0hRFFnThvlmdh7XtGp37QUMsAIK7RhnfAf0etiLc8SOFpfuuWkqoTxylloq3sGKXze++ipWNBukqCuBO6mH0qr/tO2pYlOxkpvXPl/bmqpNN1hRbigklwBKlEyf6gBRQ+QBA7sRo/0/nYiTP2orApaEUxa5wgjggc7W35EwiA6MmoyScGed3LtUweSdDAJkwCftjlk4dPTSq3ALWzpTet6QUhRmfJxvoiuPB7Jxx077tpaQsGE4HZTNgBMpyUyDSV9BOHgQcv5Q0dorLnN8C8rpVckxu/NWaVz5Rillfcyua5Z2obDpAmsw6QweqT8PWmupzfSK1dOy9sEDvrv/bRlFkJ5+VPgptx9gIhKty8dBH9z/ijNaBJMzdJJWFS54ydzduuQezxyvTF4+qkZPmfzW+0JPTPzfn3omJ1E7Bn9yiLuA0xYd1JcMJWzYuh/e0ynFOzU9sqEJ1fJy9damE4qeTBuzfIDgfGcoVBRK
 CJE7qpHm
 LZ7jXdzXGkJ1MMzxqM5YPS/Sy8HwASfvOvV7lgBE50B2uvGbtxtGyS8hMv3hD5OEqqeFzlBSpXBjrlksgkb8MmRAy4EYTpxM1J+HHcSCIyRUI5COMnbg5jt28WjLPV1Ozn/LMq4YEy0YACQPE421kSC1pKNLq+YstiEQ1dyFcODDWK/yB1i76sK9LkYZF4Ejlwb13lWVj46tzs3XkbktG0E+hTzfa1ko7v5rjB+d3oGN8RMT3iJ9xYrSt8fbLh4evOidxMNhumRHdAKwiHu7wXnCmANHQIOXsHf08yRklCDGNjSLeSrFg5vjxslJkItYUdsby9Z99IMx3BdNoLrqn27PuLYHbzjbSTJ7XzCG9XY1HA7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When getting the slot, the rcu type of the slot needs to use
rcu_dereference_protected() to ensure no locking issues.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Andrew,

Please apply this fix to "[PATCH 11/18] maple_tree: Add bulk parent set
helper" to avoid type complaints.

Thanks,
Liam

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index eb7f32081b65d..f1b9c9b32bd42 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -525,8 +525,10 @@ void mas_set_parent_slots(struct ma_state *mas, struct maple_enode *parent,
 
 	for (i = 0; i < count; i++) {
 		unsigned long pval = val | ((start_slot + i) << shift) | type;
-		struct maple_enode *child = (struct maple_enode *)slots[i];
+		struct maple_enode *child;
 
+		child = ma_enode_ptr(rcu_dereference_protected(slots[i],
+						       mt_locked(mas->tree)));
 		mte_to_node(child)->parent = ma_parent_ptr(pval);
 	}
 }
-- 
2.47.3


