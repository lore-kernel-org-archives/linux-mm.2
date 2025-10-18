Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F535CCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 15:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CF78E0005; Sat, 18 Oct 2025 11:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DF18E0002; Sat, 18 Oct 2025 11:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0232D8E0005; Sat, 18 Oct 2025 11:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E67718E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 11:23:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D22411A3A7
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 15:23:26 +0000 (UTC)
X-FDA: 84011604012.11.EEE03E0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F40E8000F
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 15:23:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of hehuiwen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=hehuiwen@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760801004; a=rsa-sha256;
	cv=none;
	b=jxomk8K76VTp55i0Win8XISAkK/xzUInZaTXj5RqAXb7ClVcjRB89ALVz5kJAsFQjuCOk5
	ANL8vEasCAxvaLM+5+aptOV7ByH8n4jikFUo5GrmeMG84mv/NfvDn3QImb04+4xx+nhIEB
	TvqYA5fjOOA926o63PLUrOP7+9YGUNY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of hehuiwen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=hehuiwen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760801004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=86/THeK/yNsDooA2Hco8FGz6cpzZ3hpcUDpbDur04Z0=;
	b=6h8EU1Z742atkrNyhsQJ6SlJLUokOvrPg2G302tBIDup/r4PZMrN1/Z8GA35tN0Qpf4UT6
	8cbEK9EL94Q9Mr02y3EuZ3bvYgfzHrkEI9dQQT1T6EZmAZjQlVyZgknAPrxJgNOWtD3a7Q
	t3ekFWtnygoVt3sGMy6Fh6K40nl+n38=
X-UUID: 5af3a1b8ac3611f0a38c85956e01ac42-20251018
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP, DN_TRUSTED
	SRC_TRUSTED, SA_UNTRUSTED, SA_LOWREP, SA_EXISTED, SN_UNTRUSTED
	SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:9657a6c6-2841-4262-824e-3fefe3e87ff4,IP:10,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:40
X-CID-INFO: VERSION:1.3.6,REQID:9657a6c6-2841-4262-824e-3fefe3e87ff4,IP:10,URL
	:0,TC:0,Content:0,EDM:25,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:40
X-CID-META: VersionHash:a9d874c,CLOUDID:cb43a231f1e62819d6fbbce3c9e6b51f,BulkI
	D:2510182147173C9T6SOE,BulkQuantity:3,Recheck:0,SF:19|25|45|66|72|78|102|8
	50,TC:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5af3a1b8ac3611f0a38c85956e01ac42-20251018
X-User: hehuiwen@kylinos.cn
Received: from localhost.localdomain [(220.202.195.150)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 555464057; Sat, 18 Oct 2025 23:23:10 +0800
From: Huiwen He <hehuiwen@kylinos.cn>
To: Liam.Howlett@oracle.com
Cc: aliceryhl@google.com,
	andrewjballance@gmail.com,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH] maple_tree: Fix potential NULL pointer dereference if mas_pop_node() fails
Date: Sat, 18 Oct 2025 23:23:05 +0800
Message-ID: <20251018152305.1612722-1-hehuiwen@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F40E8000F
X-Stat-Signature: 9d1s8mnjptq97joti3dwz3p8aqoy6qt6
X-HE-Tag: 1760800999-69632
X-HE-Meta: U2FsdGVkX189LUaS/JMFuuBsC/26qK8w0/Ch1PwUrdTtLhyjqRndFuQg2t/LX8d7JWvClB7K5qRQ0vYqhS69Ebg+1ZRMBIqq6njJrDS5HGZ+UOfpaVPT1xXxMYPw2XF/R6JLWxDk4Jm7HAHSKO0Hz+FEH88JygFn9tnhY5fM8ja8T7XGJcy2NoXUe961OqwEYEH8blbmHlIEWSdpYKhCZEi/dAkwJCTQ++n+8Dvk5+FDxbi41o2TPPWOd3oxrlvF+r1BSgnxcY3X+MVtp+mqM9GRLLwGpwZl57tIG8TqqXIsctMijridsv052XpAYO0krqVhVZMmLbHuFD2+9mgA86StQhbE/CMSBXS4YjNHxK6m6hD0ztU2qjEe09eO12YCCIJtLk3YvVNtSjrtrbhpJkyMhGq34hyFox7TXXrcjo66XKRYvTiWbWqijy0+A40YMoZXYxo/jy4rY7M+CozFeN50ot5MYWDFdKAJLoa/RDPrlQyS/h9EUhM530ZGLxCOb4b22bZUf6QlZZ9BxZyNuVB1VAdxgdIq2OutpwX5EfVUypRgHGU6juZXMSEufr3I4k+ehz2rv+Pewj2pj2Hj1JY0lnS0KJfEY+QSzdcscHRcTJ2gIfiMNDzVae0Qwne/Qbnt6p6MDluWlUzuubQ0ZvXW5+dnBT46vCchvnxuYSpn+shk4LF2p7FkKW7+c6YBhoS+fAabexOXoZ2H085cBvJnc1hpPVFl01qKA/Mw8gBsIiMyb3Ono9ee5JGEcFMUuAt6qnJxa4yQIlPN6+Lx7UqEelHeNoZIBsB1N7zaaBXCLqqqGfExn1Ii2eTuurBEkGp4M7dlukIaje6hYd+qh0rQhkN245HeN4X6aIz7dvBIZgZT3naLsey6NdkTGU8h1aYPggUKVyrtyY4IiNMJhk2qf9KST2oeFP/6U7OpgrB7o3/YNK+AAPfR3JykrMlged7DQjVIHkZiOROaJAy
 6BZk1EPn
 wBbO1gGqYue5iTtzCYo4PQ6ZgxYChQG6H9+6e78Sm62ymA3g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_pop_node() may return NULL when memory allocation fails or when
mas->sheaf is invalid. Several callers of mas_pop_node() did not check
the return value and directly dereferenced the pointer, which could
lead to a NULL pointer dereference and kernel crash.

Fixes: 54a611b60590 ("maple_tree: add mas_pop_node() helper")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 lib/maple_tree.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 39bb779cb311..524e1cfb4439 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3085,6 +3085,9 @@ static inline void mas_root_expand(struct ma_state *mas, void *entry)
 	int slot = 0;
 
 	node = mas_pop_node(mas);
+	if (unlikely(!node))
+		return;
+
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
 	node->parent = ma_parent_ptr(mas_tree_parent(mas));
@@ -3367,6 +3370,9 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
 	}
 
 	node = mas_pop_node(mas);
+	if (unlikely(!node))
+		return;
+
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
 	node->parent = ma_parent_ptr(mas_tree_parent(mas));
@@ -3506,6 +3512,9 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 		newnode = &reuse;
 	}
 
+	if (unlikely(!newnode))
+		return;
+
 	newnode->parent = mas_mn(mas)->parent;
 	dst_pivots = ma_pivots(newnode, wr_mas->type);
 	dst_slots = ma_slots(newnode, wr_mas->type);
-- 
2.43.0


