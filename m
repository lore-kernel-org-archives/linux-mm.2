Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E50CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 16:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10A48E0169; Tue, 12 Aug 2025 12:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972EC8E0168; Tue, 12 Aug 2025 12:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814428E0169; Tue, 12 Aug 2025 12:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 614A58E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:21:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DD071403B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:21:43 +0000 (UTC)
X-FDA: 83768621286.03.6D63DC3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id D843A12000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:21:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Nnf+d+BE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zOFoRkf3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Nnf+d+BE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zOFoRkf3;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755015701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4C5NtI+VD1npfCwb74mn6d30ygiQNiXgYMXuYu6v+w=;
	b=rjCKLC8Kd9r1nRKl2jxbKqohrB80Ly/pGmKMGhjz7m82cX7ivJL9z+rCCfS5SDWj8b2cn2
	yzlJBlmdCRHAgT8sUl8P76AvOrvdAr8lgWOYPfZTQfsbJOhLx+jGVdf8JzraGHpU0w2sc2
	9x1g14PuVnd7M8G3uSId1qFT3lhFalI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Nnf+d+BE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zOFoRkf3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Nnf+d+BE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zOFoRkf3;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755015701; a=rsa-sha256;
	cv=none;
	b=06wbj7pctx6wPiX0NbL5M0pNRsNQ54JE4eEyBfPhbpbngU7PJLJSplTex7o0COiQIa/Rsp
	QiSFMDdDLnauS6SGD8dGPbKsEaxxr3Cuy3JBiNjHVhO4ww6fhm+9O/FHUpTtUA089dwGIn
	nvk8uSzoL25taZDw+wl0tvR8bUhUWt4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 74E9421B49;
	Tue, 12 Aug 2025 16:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755015694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4C5NtI+VD1npfCwb74mn6d30ygiQNiXgYMXuYu6v+w=;
	b=Nnf+d+BErZu2oeCBhh8OW+VNmtAvg0PwIewFeSMnsseLzksVBiVhhpzql6/vpQ3qfbbrcl
	DbLf9/mEAKvFYaJW5LA3o3K3+8V5AcnPLchiXSBPSkXsFYgCmXlJ0fHnYIbaePc8Rv39IF
	1LjLuDHPk1GZu1mq0mDREYCymuHFCVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755015694;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4C5NtI+VD1npfCwb74mn6d30ygiQNiXgYMXuYu6v+w=;
	b=zOFoRkf3Ho0REFlPnKKQCNcB3nRPDC59KMsTGNtglYwfzV9k/GrVMc0mhS9ckDSTeJTMoq
	aGjiZ11q2XOVRHBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755015694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4C5NtI+VD1npfCwb74mn6d30ygiQNiXgYMXuYu6v+w=;
	b=Nnf+d+BErZu2oeCBhh8OW+VNmtAvg0PwIewFeSMnsseLzksVBiVhhpzql6/vpQ3qfbbrcl
	DbLf9/mEAKvFYaJW5LA3o3K3+8V5AcnPLchiXSBPSkXsFYgCmXlJ0fHnYIbaePc8Rv39IF
	1LjLuDHPk1GZu1mq0mDREYCymuHFCVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755015694;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4C5NtI+VD1npfCwb74mn6d30ygiQNiXgYMXuYu6v+w=;
	b=zOFoRkf3Ho0REFlPnKKQCNcB3nRPDC59KMsTGNtglYwfzV9k/GrVMc0mhS9ckDSTeJTMoq
	aGjiZ11q2XOVRHBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA8441351A;
	Tue, 12 Aug 2025 16:21:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SJgGMg1qm2iCbgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 12 Aug 2025 16:21:33 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v2 3/3] maple_tree: Replace mt_free_one() with kfree()
Date: Tue, 12 Aug 2025 17:21:24 +0100
Message-ID: <20250812162124.59417-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812162124.59417-1-pfalcato@suse.de>
References: <20250812162124.59417-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: eu9rxcybcdo4s71t8jpwczwzuc1k1dbm
X-Rspam-User: 
X-Rspamd-Queue-Id: D843A12000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755015700-380846
X-HE-Meta: U2FsdGVkX1/ZMOfiIviKBgLIjdJH4F1C4BIh9qFihvLNGrVB31naozyrXsrmSTcMxCbBipJGPBQMGjwkoY9z38jE/4i/6uT4wpiG3iQNj4/9Dx4oU0fJ3Hdr1lBpWX2W0gQok9HljeP9JF0ks/dKRpzyWvnsKjDP2uFaV7L9NdpTDZx8yRvWEyf4sQ40qoMrz2QigqAqJ/l1OZrCvOcQzHS7S2atuQch9dd5Ju9pEUP7lxN64oZ1GihfH7y465adUitPvRDpZkZfDIcZuMgDA0SbtFyIp5hUmBYirIwCpwh3AYIn/fxEceyQm7Mucm23EOL0xpldmFtvJIvzi1lT8pOzZs1ocqGJHeFEsXTBePsQnohXdPh4+T4ewkBvlSe4fXKGOvrMrxQ0GW3gVXKDn+BGPRNLKLC/iIJPIDc9PkGRVLKV8Utj+LRhHBDRymoGmmj0K3ElpnMH/i3i9Jj2OcQe82BcmyqpEtCo47vDav2ibTBkD0bBArma+PoBaSMHjOb3s36ftjWv7R0B7SVsMcvkcmDh8f9K74K7hgV0NmjNdwv7vXx5EwjAlkf9Gg0DGvXgLqv9tu+lSZXfLUVFW25mBSftGRVLr2J4tparJjd2tIu9xgpYyoOdT3nZcX09vZZcSxW+fonMGdeEiWz7gggs0zWe9NKNCyr7Y5vMdfIPgoc3tFegCXD+Y+0nXEI77QVsuW7TsY4ad3rOcw8CqRE7qgRjj7mx4gxJg/Ux+qTYtb9hEPqcHRBbibfq8XY+M9i6fZzGZsp4zyha7Y/hK7/vfO4rNHkGMI27J9vbDaEUwNeuaaBEBjOthizPSDmYYIdFlrvmekrltd+baYLcU6+Z8ZRTNzUCJAN40uZ+laOKBGtD3EheasiZRBfFVP7VWhl14V70lQSVxBbAIfFLH3ybzxkWhOlwyEnbLX/jxNNdVhWox6odhYSIxsUH4ZYddTJCXV69OIOaw/L8D/I
 EWh2Ehf8
 dD1PSXDTIf4qiMHUdWvNC/+RvalGTYlxGaTHLQnGcLCyzRcKBbbT484JOE1nR6xExoVbRzb2R1O/ps28jtPsom+p982/bW7s+Yf7QPNp8InH40A6fBr2TAm/CPBW51BnekgrzRPcOfLUwxoB1LrwsEKOIFBHtrbz0mFF5PyWW5x74FvwMW2opigTLNqHaZkvw3zuRHELmEz4fBEMEcl9fCazJWf3Y1UoC5qRmUZQI0cOQS9hi5/nsZlsUN2XpELlZAc/lD/QFQI33jnuzLq4n9bW38iDT7iDFnSqr3e3VR745uw4rklj1UYzHcq3yxM3rOb12zOA0K2gtmQPPUA7sGzNKnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kfree() is a little shorter and works with kmem_cache_alloc'd pointers
too. Also lets us remove one more helper.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 lib/maple_tree.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 91da2d9d00c3..3b756f1b67fd 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -181,11 +181,6 @@ static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
 	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
 }
 
-static inline void mt_free_one(struct maple_node *node)
-{
-	kmem_cache_free(maple_node_cache, node);
-}
-
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 {
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
@@ -5274,7 +5269,7 @@ static void mt_free_walk(struct rcu_head *head)
 	mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
-	mt_free_one(node);
+	kfree(node);
 }
 
 static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
@@ -5358,7 +5353,7 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 
 free_leaf:
 	if (free)
-		mt_free_one(node);
+		kfree(node);
 	else
 		mt_clear_meta(mt, node, node->type);
 }
@@ -5585,7 +5580,7 @@ void mas_destroy(struct ma_state *mas)
 			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
 			total -= count;
 		}
-		mt_free_one(ma_mnode_ptr(node));
+		kfree(ma_mnode_ptr(node));
 		total--;
 	}
 
@@ -6630,7 +6625,7 @@ static void mas_dup_free(struct ma_state *mas)
 	}
 
 	node = mte_to_node(mas->node);
-	mt_free_one(node);
+	kfree(node);
 }
 
 /*
-- 
2.50.1


