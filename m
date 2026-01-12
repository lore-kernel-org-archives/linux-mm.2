Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CC7C9EC90
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C546B0088; Mon, 12 Jan 2026 08:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA216B0089; Mon, 12 Jan 2026 08:59:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8B96B008A; Mon, 12 Jan 2026 08:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46E986B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:59:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3E0C140267
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:59:40 +0000 (UTC)
X-FDA: 84323469720.12.B350B2A
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id DC5B8160006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:59:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768226378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=livaW3oIXyXZxQFDJCHnHTkVRcx4EfdUKalygiBT9bA=;
	b=nkWFRVaL6HxuG1SQ/R2iK4A2KY0mmi9n2qohuPP4ElldY20SeGahaed8ROqp0FVcAUAqK6
	YIP9U4Xgt9DUH1GajO1MQS8HjSozHrz5BXH4gpkUqyO8DCTwVPLB4igFgZrR8m2WlTXtAj
	qTa7vAY+sQD+aNr4J/iWaPzBhJ2jZP4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768226378; a=rsa-sha256;
	cv=none;
	b=KFH8uBwpnwEoWj3y8aGRJkan7gLmM0JFhvfA3K4PLs1DqJTjbOm+qBOx450F5TiwUupGoy
	iyp/dsSWvIN2GGnTmzZZmOFppe9Mcq61FyWZNFuBxnSuDj0tiMljwqFoLrIkzv72mEsI27
	Zoc8D3I9960IDUhGNn795TSCR9+BJ6I=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4dqYsK1BS8z6Fy68;
	Mon, 12 Jan 2026 21:59:33 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 60CDxN6Q091867;
	Mon, 12 Jan 2026 21:59:23 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 12 Jan 2026 21:59:26 +0800 (CST)
X-Zmail-TransId: 2afc6964fe3e1af-29690
X-Mailer: Zmail v1.0
Message-ID: <20260112215926745u6X5PObjPFC-IXAXj0BU-@zte.com.cn>
In-Reply-To: <20260112215315996jocrkFSqeYfhABkZxqs4T@zte.com.cn>
References: 20260112215315996jocrkFSqeYfhABkZxqs4T@zte.com.cn
Date: Mon, 12 Jan 2026 21:59:26 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <hughd@google.com>
Cc: <wang.yaxin@zte.com.cn>, <yang.yang29@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDEvMl0ga3NtOiBJbml0aWFsIHRoZSBhZGRyIG9ubHkgb25jZSBpbiBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 60CDxN6Q091867
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Mon, 12 Jan 2026 21:59:33 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6964FE45.000/4dqYsK1BS8z6Fy68
X-Rspamd-Queue-Id: DC5B8160006
X-Stat-Signature: 1smkb1zems9j3nqdwkinux9jkfjubrbs
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768226377-748342
X-HE-Meta: U2FsdGVkX19mF5zpJmC8Piq+7DGWj1MUeMkb5RlxQQ2E/Dpfi/anQ8uVOtgnU7ok1MoXlGFoGOWdvDdGP6A2q/OJWS+WVrk8TB6w7VV0I5cXUuGgJkg7EV4GHGPnq9vIn2PqhVWLnjtYbs3GrjRhUej9/V/UzYIdwNYu4if3Z3SOrHSq3FSGZ7j39QMQiL5Ax0dAMRGS04EEhgjO/wpEv/6h7+nAGDZDyLEmtKtnwF9RFNiL8/39pK69V+sbMgkGHZtOb17YwC+MbUD8O5C31rWYeErweTARZ/kyWz8IbPBoAGRbXkx1cD9l0cGLvIsYpXt5sfqj2flDt8qrcQ6de3o793Tr25YcPuLjSRjKt3PPZS0mLJf22AqH2djAAd2zXUVrRbr6OCGI75z5HXHibXFnqQGnEGmVV0POPACfZ4iJayb7zmYbbYeenCuBZBO417fbqH9zjm843kuccNrrD/liJbtLw4ibuZuKNJYNe3DgNYCA4U+fbqzFa3jwLG4/2MkPboUfQVIhEzPydWsG901ZORcs/mhqPYkqQA2JTwP6QinVTFSSYwmQ0oj/i5zWiQRUs4wPP9sBa6v4C/GYlgotf5X9MxOljkdRTaq0tSe6TZU0jo+KpCjjQ7XFaMhvIx3DGZxSxb8ULwvS6zpXXCApvViGOs93+g0ZAo4wKXoNlHGCPfUmv9qeJ6AmnslEIrHX1AMOh3697lsfHBq5u6Mz+RX9DepHGfKMri47PeF56+q/zjHAEA56/I2I8/RP5bni9OLNV9+5j8WlyVCI59I3gBYyi+JxREOza95dC1HVtnaVKC4u8JAU2JDxsQ/U5yUa7BOuUU46brXl2jzdhCMUI/bnNzhblEKx69sjre1rB1NZ0f0gMMxCfw5YqEzNlNRDRRvHLqTLOSkHNA54juLJ90xSxvquy6WVG+0dNtG9mue4g9fPika4ApkIYV17/G8zCJ5n0lTOHjdSoDK
 KLwdpZxO
 LHO4t0/TBC1Uc3G438RJiK5waqwrYo98yL9jsr+r8wvWnaSy20ge1ukq26sULME77ftmKvgBEW69NQczALFYD3qqZRk7kJAPqdmKpTRP1ZKfvqo+pD71lSdUmXa1ONm3bGHMzYAEkSFGR9JHQGVbaPd0ea7PFZ9ryMXImYMZ5R4YEaXejGCX2jhh2dxtW+nwDNlt2em6FkNS59yIMTv5l5rkxlU96QoNl36uK13DSppUxJUFNJ/V99lKgdsIUp+WqPGlyxtd+7Wj/+JeN9CywzWASoKd0bl1NjAcCn3eHfZh/d+La999Gv5y/RyffCiKxPPYLvDm6vwierBlEt6hYhlhImQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

This is a minor performance optimization, especially when there are many
for-loop iterations, because the addr variable doesn’t change across
iterations.

Therefore, it only needs to be initialized once before the loop.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index cfc182255c7b..335e7151e4a1 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3171,6 +3171,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
+		unsigned long addr;

 		cond_resched();
 		if (!anon_vma_trylock_read(anon_vma)) {
@@ -3180,16 +3181,16 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			}
 			anon_vma_lock_read(anon_vma);
 		}
+
+		/* Ignore the stable/unstable/sqnr flags */
+		addr = rmap_item->address & PAGE_MASK;
+
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       0, ULONG_MAX) {
-			unsigned long addr;

 			cond_resched();
 			vma = vmac->vma;

-			/* Ignore the stable/unstable/sqnr flags */
-			addr = rmap_item->address & PAGE_MASK;
-
 			if (addr < vma->vm_start || addr >= vma->vm_end)
 				continue;
 			/*
-- 
2.25.1

