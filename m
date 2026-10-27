Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE459606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vpwq/f5x
Received: by kanga.kvack.org (Postfix)
	id E86B36B06EE; Tue, 27 Oct 2026 12:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E496B06F4; Tue, 27 Oct 2026 12:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74856B06F8; Tue, 27 Oct 2026 12:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AED296B06EE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:12:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40256120AB1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:12:14 +0000 (UTC)
X-FDA: 85368898188.04.DCEA99E
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 862D0140003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:12:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vpwq/f5x";
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48V2i++CxoO9ErJxlzp+qOCNmqGeLS8hRD7IL1WVdDU=;
	b=b4KvvOxFG3XU634vd4CsBfqFShleqbrSwvSYpeOvUM2/n1LTXd5aw2L9EVFzhmwxQxjNGx
	slRPM/zoebRrSKAykfkHuGvwwgzx9xrLVB5HA24ff38FLAykaiuv2vADQRrLNz7cyTAaN5
	PsJJR9thyGG4dGJ7roZH4H3IR1I6GvA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vpwq/f5x";
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117532;
	b=t36/R/sV6GuNZBiZMNYpQAZ6cgzGAuZvNdJos6EGSMyAvkIUiqsfLFJ7x2PRG+mq/4zGYw
	gWB/s+lLEjo5ccIvHAkBRpL2d1TEa3PnJnLYtrWJCPehp7SBZuDSDtV8KRPCyh0S19nbzA
	ebHhMQo5wOedS1Op2lKRMZbuJEFk+E4=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc147d86bebso11889a12.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117531; x=1793722331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=48V2i++CxoO9ErJxlzp+qOCNmqGeLS8hRD7IL1WVdDU=;
        b=vpwq/f5xJJcaD43iiiBs4MIDUw/8HzNq4dfUzvAtfAESxpoYtSCkqq14Em/cZ30+EM
         hgVxzfJebqdI4CZ/u80o3u8VacVl6Aws6alR0dX2HamC/j87qQUn4JUQHpTSH1E4yXRi
         H2K+8D08WTLE1yqimwMrywnLRyHh9huLhpEJSE09oJxZMbc+16WhPt6aSTUS31DAzYpo
         31hPtJFkURiVRwBfohhFpMYPpKQc/oEbyrh758od5Vx7pVsmP8H0gdRNRvFNDC0fLW5+
         rf/dN9xqZEy30araS0c13xYjMx5bHCS4kl2Xcq+oPFYbaAoaTyFz/er52K08+cFEIY+L
         TmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117531; x=1793722331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=48V2i++CxoO9ErJxlzp+qOCNmqGeLS8hRD7IL1WVdDU=;
        b=wOHDVA9dBwtXE9v8EtOWYAqvHs/mhJaOeRb89UFRzeEj93npRAWE7IrJTkthSRrRnQ
         GmN9qwdWYWnQPEKnYBrni8b6A8OhSksymL6xUsNO9ADSUWcIck2vwJtYSrZZYSa6m7mz
         ohTt4bUlvIozrfw8JtDtZewz+knM7ituWvSGDLCyW6QB4Yycr5VWsU1Dec3mBladPEru
         Xn1eF57cW4fEs7yx8Eg3X54Pj6ctZ20YdWObAqxDVKqvrq3ZF3QgjRkTks2stKt9UTG9
         cK1q99Yrs7/O/eld6qg0f2PQaU0t73EDuO4kRxthVFokntP6mUsz/pyJPus1ZUJqQxqT
         VT5w==
X-Gm-Message-State: AFq9FYKkOLcF4q6GQMRk+DoNxcFKQs1r5ldsM+WVjd+RC7R4wPzK23+u
	UK1FpFKUxUBxbID79lUlqbp7+2kTcas/S+9e6+CuEWv/IMtm5cYHRNoCtRDyGg==
X-Gm-Gg: AYBFou0I7M/Zi951KVr1mx6qH1Ev2UqluLKLQFuASLRn9Y/mrdbqxQuUErETE4L3ak5
	eC50vOmh/jJac5HaJSPGS7s7dl2YIo0ccQrIMCDPkHuNfNcfYi2jTv4Xc4geNo0tKwVvWZvsKo/
	4eGPgNbRYvASDusZ9c7c0IgdlRpW22bxBAg1r6VN/HF1lyUxIcgUyJdXT9HhX31bc2ZxBxXPeUw
	2prO3Udq+Gccko27oNCt6kUyuMeFcS1vDtG/K9UZTZw8jPjFE8NO+k1hpIAzgHJmP1BSGQh4ifC
	IDBEQORpM+6s6OBduzcO75KyxXxoHd0TpTuftGaSoszYLmLLRHCo+eT+IgiVQ0dWYKN7bYrF7B9
	j56rZWNeD5CQYIY+26GWVgrVS1tDUOHcukk61DmXNZVv+slLYUrBCVplPmHm6lPudGqk8Jlag3R
	WLh0e3K7ZtgJCQDhXKy+t06BYcFNYR60vBbTmjFwCx3rNh3qk8Mq9wVM8TG9RfbjAd1/Fln63tZ
	zfmNBp23vUFDwBRNvLbxgXIASNNkjdl2MOzzJlb4XTXgIIzBc5xutvRejlj0h4uUjt3iYkB8pRd
	dUSptruCspSZRyc6CnKkGpsa+sr6E43xH3ROwjDQFjZdw2LRWAP4P+q/DslESMyuB44OdA==
X-Received: by 2002:a05:6a21:178a:b0:3e1:a27e:302e with SMTP id adf61e73a8af0-3e8eab1a4dbmr1746535637.24.1793117531324;
        Tue, 27 Oct 2026 09:12:11 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a72c9f0asm252149b3a.46.2026.10.27.09.12.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:12:09 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 14/18] lib/plist.c: remove requeue function
Date: Wed, 28 Oct 2026 00:11:44 +0800
Message-ID: <60abc13d07a46750d14478d9cb4bc1ad480321ee.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 862D0140003
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: kkkzbasu3hb9nmxfbmjc6z1mgnqekb83
X-HE-Tag: 1793117532-966304
X-HE-Meta: U2FsdGVkX18j3EOgdkvRLM+QIeN7OiWkqWLdGXFQ24p79AlI/fm4OMpVHZRbDKYXEehZ/680QKPS1z0M2WZQz4XSyAeRoSUGKigKbGCAqsDt191IgbSVsTpzuDeHkvQ0HWjVeI59xxuAXpsSh41LaZYWEgoJ4FsYM5sZ7veHYhBML+Wzw2pXe2tP+Ww/zYLZfWTtM7e+4k7u9Hj/1cDc2JvRGlt9XKJ2D9BS2aVYySGM3p1UOiEEJ5tnGzKuLw5xGuXzRoK5+eXocFTN0FdTJ+anIDhLl2Mt4Og+vjxyonpCCfwhy8lKKRly5cv99xB0++KHCWT7YXIA0X3OmpfT8Ra6oyIi1Vegpy3h3VBIZwZaMYrQkT87ploX58zlONc2XDBsP2i/HWh22Qgg2JkPniueY/hXNr+w8KunenjjOBogzSPuhY4kZm24Mf9RisBEQzb8bbLmitADGi403fRqj74dhh7CyrAKbmJi6so5fK9zzJrxzYntQ4b0l13xWGQN8wHweOXnSiZgyCNZ09RM5x0y/NfkHUyiBba0FPNBfFrNpD2B4wxuG8OJYTMon1bCe778bOYZM9+UYgUcTqTWoMib/1MKKicCdPqMQ6n7rnonA+HLXZudbGPLu0Sep6rSX5U4ylkoumh9Faa4gdGF8OKQEPOY6EF1dsGlmXuxuL39Mz0MP1aaTi+kytctDeKKPH/qVX99eYKbwzeOEJJu5To5m3qnKK3fj/DZHCwgwilRCEkCvw5FZNb/AwZLwvgMFvaubmLHmbw7fJezXNaJVngqNBrlXUR4/sGRLheJrTSgbotd9kC8DKazT8E5MOYjWAesZTJibN8pFJYW3Cw9fzcbsZt9cP4DozL7XDHd7IWEvnvDXaL/SHpXSpzNR5CsxT/cKkMN/LeweSapLERYsr9DV4wjSO9UhDASuUdnm8SpV21YVPZdD2eAQRNRiLlgrzTN54xqug1PCZ5T0ov
 2ErusO6G
 8FIuZhc2j4rJiH5w3eGiGWOCr0zhCAWUPZ0ptB1BWfRDcgx8nggBbDulVQl6oZWURmIZIByrrtrDYDv2112fsl7NqZhfdZJmsJ8wqjlBJPtDAat4npAK+8GI/G5yuFhjtRQ4377sBOGvEkRiAxfUINX010JM7sfYRrznPOvlCUCoO6XO7FfF+ChZ0IzJu1Bft4pmfLu1Dz0dgjRwsevysP7EEPP5+qRTWc3HiXiLZuUDjdOXKt1+9JTGxEwQU17GixpvPgJO5b1ezDkH5nx2vt2NKpG47j0fuvX0iEr8IEbOZNcqTspUDog0pLHYKO90yayao3pHhC38Kvx7M35ns9ktAWoT1aY5HEm4bpnGot71OedWakk059wAyEOWBNSC7tZuDLjKVw1u/T4prRZ78gVzn11jkvSponJCfNwL96SNoebBkxYAbWbKeYcBrincJic3SqDzi61FhDz0wGfMDtR+pjv1h28NjzVveq5J4wA1Z6BkXaFovEyXFKKK4G7Z56WIr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Now the last user of plist requeue is gone, this function can be
removed.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/plist.h |  2 --
 lib/plist.c           | 64 -------------------------------------------
 2 files changed, 66 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index 16cf4355b5c1..73d359c1a053 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -132,8 +132,6 @@ static inline void plist_node_init(struct plist_node *node, int prio)
 extern void plist_add(struct plist_node *node, struct plist_head *head);
 extern void plist_del(struct plist_node *node, struct plist_head *head);
 
-extern void plist_requeue(struct plist_node *node, struct plist_head *head);
-
 /**
  * plist_for_each - iterate over the plist
  * @pos:	the type * to use as a loop counter
diff --git a/lib/plist.c b/lib/plist.c
index a5bef38add43..b05ae7ffea87 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -142,58 +142,6 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 	plist_check_head(head);
 }
 
-/**
- * plist_requeue - Requeue @node at end of same-prio entries.
- *
- * This is essentially an optimized plist_del() followed by
- * plist_add().  It moves an entry already in the plist to
- * after any other same-priority entries.
- *
- * @node:	&struct plist_node pointer - entry to be moved
- * @head:	&struct plist_head pointer - list head
- */
-void plist_requeue(struct plist_node *node, struct plist_head *head)
-{
-	struct plist_node *iter;
-	struct list_head *node_next = &head->node_list;
-
-	plist_check_head(head);
-	BUG_ON(plist_head_empty(head));
-	BUG_ON(plist_node_empty(node));
-
-	if (node == plist_last(head))
-		return;
-
-	iter = plist_next(node);
-
-	if (node->prio != iter->prio)
-		return;
-
-	plist_del(node, head);
-
-	/*
-	 * After plist_del(), iter is the replacement of the node.  If the node
-	 * was on prio_list, take shortcut to find node_next instead of looping.
-	 */
-	if (!list_empty(&iter->prio_list)) {
-		iter = list_entry(iter->prio_list.next, struct plist_node,
-				  prio_list);
-		node_next = &iter->node_list;
-		goto queue;
-	}
-
-	plist_for_each_continue(iter, head) {
-		if (node->prio != iter->prio) {
-			node_next = &iter->node_list;
-			break;
-		}
-	}
-queue:
-	list_add_tail(&node->node_list, node_next);
-
-	plist_check_head(head);
-}
-
 #ifdef CONFIG_DEBUG_PLIST
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
@@ -231,14 +179,6 @@ static void __init plist_test_check(int nr_expect)
 	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
 }
 
-static void __init plist_test_requeue(struct plist_node *node)
-{
-	plist_requeue(node, &test_head);
-
-	if (node != plist_last(&test_head))
-		BUG_ON(node->prio == plist_next(node)->prio);
-}
-
 static int  __init plist_test(void)
 {
 	int nr_expect = 0, i, loop;
@@ -262,10 +202,6 @@ static int  __init plist_test(void)
 			nr_expect--;
 		}
 		plist_test_check(nr_expect);
-		if (!plist_node_empty(test_node + i)) {
-			plist_test_requeue(test_node + i);
-			plist_test_check(nr_expect);
-		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(test_node); i++) {

