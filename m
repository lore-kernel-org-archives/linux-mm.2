Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95A2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D7D6B008A; Mon, 13 Jul 2026 02:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEBC6B0092; Mon, 13 Jul 2026 02:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7166B0093; Mon, 13 Jul 2026 02:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB816B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:42:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1033AA09A4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:42:09 +0000 (UTC)
X-FDA: 84982808778.26.9E95AE5
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id DBCE680007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:42:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783924924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QPJwp2shjWbBOeD2MRroVQMHgWpHcf/Ngz26LV08aRg=;
	b=ZBrML7+FPts4vnL+KsDnpX65D5BePPHDlJh+RXuyEp8miqhi9o64ccIB7uqlYs06V4gCVO
	bOjW/vXGi/EpCqrO/0R3rRjIGG+I41BcW0FoD8eBD762igH4RB0ebNt64YjsNp33HfCS7q
	mMTTuHVLpxFrBths83ATpvUFcbyqLu8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783924924;
	b=4K6dQJEDuOLUmostL4NVlRpaioRCeKNOaIO3PTndSeYucxmCC7Dx3Bf8FmMq+QXAExlJ/t
	1su9wgPHJsICqoPLPInXpg1ogShbPHZw/HxElY8+5JqnuT8NR6uS2PluMT1NSAPmYah7ji
	nfjG425HEj2Wtv2kxvJOPOQq/KXumWE=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gzCXT5GDhz57DCs;
	Mon, 13 Jul 2026 14:42:01 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 66D6fpuE035154;
	Mon, 13 Jul 2026 14:41:51 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Jul 2026 14:41:53 +0800 (CST)
X-Zmail-TransId: 2afb6a5488b1c0b-5ec07
X-Mailer: Zmail v1.0
Message-ID: <20260713144153556amKkr4s-dWoQu5-ziCfZe@zte.com.cn>
In-Reply-To: <20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn>
References: 20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn
Date: Mon, 13 Jul 2026 14:41:53 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
Cc: <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <wang.yaxin@zte.com.cn>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDIvMl0gbW0vbW1fc2xvdC5oOiBjbGVhbiB1cCBtYWNybyBwYXJhbWV0ZXIgbmFtZXMgaW4gbW1fc2xvdF9sb29rdXAoKSBhbmQgbW1fc2xvdF9pbnNlcnQoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66D6fpuE035154
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 13 Jul 2026 14:42:01 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5488B9.001/4gzCXT5GDhz57DCs
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBCE680007
X-Stat-Signature: fxd5w7tm1eerzuim15fjm3k54ozm1159
X-HE-Tag: 1783924923-538642
X-HE-Meta: U2FsdGVkX18uQApjBRlDvjphn9p742bdDrGO8bqxWfD5lWKv+a292eEXW0Gnh4reETcYBKQqxUEcbE5DiFR2FHM0Kwh6Yay7QFpXq6QmUxaqLmVEVpamEOGSKfAF5PNRCxSVeJU90OzkG37Mw8t7lxFcJTqQFBQiMZgqaDpOq8XJMyIwIps3wwh8tf2joH+43PRliD9ipXUTVEiJ6R9K3D0ukFEBZmoCaYNKY3E5YzaKtrYTzf/KZT747cpE01B/YSlfMTHhTwdz07pg/6aBHQ5+8IsBmAX43MLiqfQG0aLu8Kz6DVtzNerC1z2WlUX5jUex9+yBfOZLElI3tt+rAHzgmtfEBFb2pNOD43ZQMlz7HaqD1ul9RLQ0/YBhRHenkWkjwPapUzqCwxdgpuZWxUgAE0TX5wJiCxfiEbYySml8FfL2YzZ7irt7Hwi+GZhzTwvzCX+6hgv95eTdNCX9PS7jr6xtW2r4B7IzUonjxhH70eIvjtxkuViO8caRi+FGjsKXVJgp6Gm/MJeRhC0k66ROiOhhRfpc1HIyg7wx9PNIE/UZwwhFFHEAJPkEN0Ach7SxUS6l/qK2wJPRaz/QUAG/y1iewokIcVF4U6Dga6ywBSXOfOWegFDHfuuSSsjYJH+cWwGjBi1i56ulpjG+ud55GV9c94MnbaZBmfOkF+P2eO8QU09WUTV8+y8KdnaR8hw7Fvd50HofUQ1/jlCAukRAUVNgbSr3F0Z044XFVeG7uFJSpR6zT0cO1E4Eot9NZVzQAAfHS3JRehAffPkkskth7ixE2jtDxT6lPRM7VBYQAuMcjfhSnOt7whLK8EUOCYB6hvOIOtYAaVhWmXUBeksUzPi2xi5DwUS+Jwm6d+VbKCd4fVFbxg9pJIpgaRWPDBqtBdicWFTDXue50mfirJCycyW8Z1QI4SL/Zv9rljTl6CrG4YGsClzXwNd9Ww0fQP60XCOKBKGy3TzVfoP
 OXVvRFpn
 J4vaIG5aHVsO2t7SyNC/3bh7RC+UKzCcnYQLueDS0r9GNZ40yTHCEFcs0Jlzj/UQsbku+bGwhQqVvFLSWERB7yAjeBqTug/KtQsE272HKjZ+MnJax1ZDoH8wH8bIklZnynTB8HvWSPFWxgOvIxsP3IuIlCu6SC1k3RIAGLct3yNIVL+iYQm0elcd38vfIGro7GAXTPzI69EiA3DjTbafSa6T30r4umKulX1/zUJ+GJEgwO9raLm7gxD1YyOvf7tfo1NAHDY2DUSMN1k6PvxFodGVOu5StW7IYPqz+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/mm_slot.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/mm_slot.h b/mm/mm_slot.h
index 5de3e91d86b4..710c70166c79 100644
--- a/mm/mm_slot.h
+++ b/mm/mm_slot.h
@@ -33,12 +33,17 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
 	kmem_cache_free(cache, objp);
 }

-#define mm_slot_lookup(_hashtable, _mm) 				       \
+/*
+ * Note: mm_slot_lookup and mm_slot_insert cannot be converted to static inline
+ * functions because hash_for_each_possible relys on the actual array argument
+ * 'hashtable' for sizeof() instead of pointers.
+ */
+#define mm_slot_lookup(hashtable, mm)					       \
 ({									       \
 	struct mm_slot *tmp_slot, *mm_slot = NULL;			       \
 									       \
-	hash_for_each_possible(_hashtable, tmp_slot, hash, (unsigned long)_mm) \
-		if (_mm == tmp_slot->mm) {				       \
+	hash_for_each_possible(hashtable, tmp_slot, hash, (unsigned long)mm)   \
+		if (mm == tmp_slot->mm) {				       \
 			mm_slot = tmp_slot;				       \
 			break;						       \
 		}							       \
@@ -46,10 +51,10 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
 	mm_slot;							       \
 })

-#define mm_slot_insert(_hashtable, _mm, _mm_slot)			       \
+#define mm_slot_insert(hashtable, mm, mm_slot)				       \
 ({									       \
-	_mm_slot->mm = _mm;						       \
-	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
+	mm_slot->mm = mm;						       \
+	hash_add(hashtable, &mm_slot->hash, (unsigned long)mm);		       \
 })

 static inline void mm_slot_remove(struct mm_slot *slot)
-- 
2.25.1

