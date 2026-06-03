Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7594CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EFC16B00A2; Wed,  3 Jun 2026 09:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C78E6B00A3; Wed,  3 Jun 2026 09:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405036B00A4; Wed,  3 Jun 2026 09:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED6E6B00A2
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:10:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4A1212033F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:10:23 +0000 (UTC)
X-FDA: 84838635126.12.ECBCF0D
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7ADDC4000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:10:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780492220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=+2psCEdHz2MlqyTpA1+7BYHrYL+dorP1n7QDY4omABw=;
	b=hWU1Q1rIW9ZEMIQdIYofZTe+o9n3HvwG2J1ZS8IxwgprTtwaB0olZmJ/aha2XkejpplkKP
	cq7wD8sSyx7hwxqa2dEI1vOaIE2noVmLzQJK9lC/28Yg9Tj+aTn/Mdt2ff7VhGBHvSVLfc
	Btb4z/ECtcGryfRmLB1KZo1W2qalbZs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780492220;
	b=LroX2aWl9Rufnz1TFZp1ITgp4yDgwC7FonuB+yZsJNvFMcAhJWozBo4xZ9vANW3DK+PIXL
	YkTS5numt+V+yzsGxN8t1LdTM4BX+7puSJODtshi7/IHg5hw7ZFNA0tib4CZa6/GKETFwS
	wuTdXMvjz9cdXG0/DQ76pjZd7TmVfZc=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gVp2x1yWRz8Xrnw;
	Wed, 03 Jun 2026 21:10:17 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 653DA9B7074276;
	Wed, 3 Jun 2026 21:10:10 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 3 Jun 2026 21:10:11 +0800 (CST)
X-Zmail-TransId: 2afc6a2027b34c5-453bd
X-Mailer: Zmail v1.0
Message-ID: <20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn>
Date: Wed, 3 Jun 2026 21:10:11 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9zbHViOiBwcmVzZXJ2ZSBvcmlnaW5hbCBzaXplIGluIF9rbWFsbG9jX25vbG9ja19ub3Byb2YgcmV0cnkgcGF0aA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 653DA9B7074276
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 03 Jun 2026 21:10:17 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A2027B9.000/4gVp2x1yWRz8Xrnw
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7ADDC4000D
X-Stat-Signature: gq1bp9j1fqruko5eh8cgo5newaxasehq
X-Rspam-User: 
X-HE-Tag: 1780492219-724846
X-HE-Meta: U2FsdGVkX1+WqL35mtLFro7f4RoRoEGvugIwez+3wa7c496OQ+eDQcQTXk+WmS2T16AjhkVAWgBvoMyksbrn3QBzZVSNT1+V+u2coMSZiXaB5OO5PENntk+sSV3IMLD2Hi0fSXB2pSJ0nEBRzB2H2f3P6N7nZDshWVCkrWoyiZQfIRmwvURXld5+opUljkbspNpA/9vYYspX9vG0pqOvCsyK5fxOCvi+8HnxH8leuP4SYepm5utWW+bOBT1+S7cfn29i0+r/GqMkkQQ4IKY49/lepTZF9WkucAmPG6Gp0NMfIu5u1lSykrzODfGdcm2ClfHWrJTls66UwyHvOl42d0bwCvt3+QgWYQJk/TfIDCintJvzWqswNBEuRtxWit2XbDQF9xZ/MFBI2JRh8UMOQdHBj8MOlMPiJkVIzE+Xy08MIUpQxwSANocScXS35qUbk4KsDfqbJYu9t2vNp3JCfd09Od3qrnrmyM2/ahsb6ZXECDFKrsMt8b8QTOMMVGztbCG3weA0/8UAt7zWMYd5ngSKKlfGTThbzfbq1tSSoKaE/2LK/gLCrwb8xE4OtWp8b7EIxk9+AsALFQMrI9ksjo89dfSUbr2CwrA156BW1M55HgPbVm8IfvzxE8tM2ZuKbpkR5wEgqBvyLE/5lKGlJvUosQfsHYqQtk1iV4j+yB/DUEOZrOQ/D1dAAanIY3pchvei/qGZGKYtfY+y2Kb8eyiX5lEkzvCa9+MKFBpfGKLsdApYQ10L7R2JKUB+jXYcwbjPTvRClnE0S1sldDWQAo7LRHUi8axi7C+t3z3qarvBK/Ns8i+4yHP9wgESxV6MchHnUKcgF3aqpaR4iroIZXcPDrab/GLqpdcpcoQAISgFlIq38FfruaaAHrdPGP4TrdLIEEzx0hA1NaiFZkTNjC9BuELm8cKqnf2BxmWEc/C4qMCFda0BSZ39Zk4bs43utVT4Rlqz8/i2JIpAvcB
 cZ5K/RZx
 ZCVCPwT4WUItD9oZjwRbCerER0zvtmMn6/1Yo/EJQBXrrbm58lWoC2RrfDrEPZGLUxCq03DU2CcRY9eOEawy8wifbvMnRKeNKlZSx1kLthP+v+WJBnX5COgLJneycdvIOME9/F+HsrRIfKX4Opc8mwvOqZckBpvC3UBFrWokFRjtLUecmekciae8MotE34Hpnij4Dt7bJLB27TAgLLPthV0ogXo43RkBdmXXaaKjgka27mnCk2VGZPM/qVN9gnUDxL/AZheYL4BZbE/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

_kmalloc_nolock_noprof() retries from the next kmalloc bucket when the
initial allocation fails. The retry currently reuses `size` as the
bucket selector and overwrites it with s->object_size + 1.

That value is later passed as the original allocation size to
__slab_alloc_node(), slab_post_alloc_hook() and kasan_kmalloc(). On a
successful retry this makes KASAN/slub-debug observe the retry bucket
selector rather than the caller requested size, potentially widening the
valid kmalloc range and hiding overflows.

Keep a separate `bucket_size` for choosing the retry cache and preserve
`size`.

Fixes: <af92793e52c3> ("slab: Introduce kmalloc_nolock() and kfree_nolock()")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
 mm/slub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 67abbbf68fc1..6a2b3ade3611 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5350,6 +5350,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
 void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
+	size_t bucket_size = size;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
@@ -5372,9 +5373,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		return NULL;

 retry:
-	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
+	if (unlikely(bucket_size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
-	s = kmalloc_slab(size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
+	s = kmalloc_slab(bucket_size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));

 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
@@ -5408,7 +5409,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	 */
 	if (!ret && can_retry) {
 		/* pick the next kmalloc bucket */
-		size = s->object_size + 1;
+		bucket_size = s->object_size + 1;
 		/*
 		 * Another alternative is to
 		 * if (memcg) alloc_gfp &= ~__GFP_ACCOUNT;
-- 
2.25.1

