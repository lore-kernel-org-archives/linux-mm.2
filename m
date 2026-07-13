Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB58C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7738A6B0092; Mon, 13 Jul 2026 02:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74BBA6B0093; Mon, 13 Jul 2026 02:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B976B0095; Mon, 13 Jul 2026 02:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45EC66B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:39:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6CB01C96AE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:39:03 +0000 (UTC)
X-FDA: 84982800966.26.BCDC463
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6AE4F40004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:39:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783924741;
	b=mRlaYWMQbJ6rgauXaPq+jIKFhNosEDWufQXNkl5YjYLwjODKajfS6dgnti7B9d6EUHiMi2
	Fmc+psIvH2m0nS2eQNWIZZ9k4XDibTfNJlPB1tY0f2NFjYzX5M7dCiZt2XKh0vuxUpcjlp
	6EBZcykjaf9C6L0VXVqEJnvcLR+ZyVU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783924741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxqtTQL7RKJkz/VNMKj8Wv+Cf6pzRERBjYetc3Pb6ao=;
	b=yE+9fk/hVSIzpcXkVv1qdJAp4f+GH0dkIIJR+hSlbYPiQpnnlSRA/Q2vdQqvbhHuNDjwU7
	ap/oiywNg7yXRGw1auMYNzCoUqs3r3Uv53MO4dWyolW5kC/pmRqf4Fv4mK1Vx+CX20D6fF
	W74lYg+u5P9wrl4S1Fmrha+ckAF3CE4=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gzCSz1KsXz8Xrrb;
	Mon, 13 Jul 2026 14:38:59 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 66D6crWj030739;
	Mon, 13 Jul 2026 14:38:53 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Jul 2026 14:38:54 +0800 (CST)
X-Zmail-TransId: 2afa6a5487fe820-68812
X-Mailer: Zmail v1.0
Message-ID: <20260713143854774IDQ756lKhFqhw7CX1qaXc@zte.com.cn>
In-Reply-To: <20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn>
References: 20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn
Date: Mon, 13 Jul 2026 14:38:54 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
Cc: <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <wang.yaxin@zte.com.cn>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?bW0vbW1fc2xvdC5oOiBjbGVhbiB1cCBtYWNybyBwYXJhbWV0ZXIgbmFtZXMgaW4gbW1fc2xvdF9sb29rdXAoKSBhbmQgbW1fc2xvdF9pbnNlcnQoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66D6crWj030739
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 13 Jul 2026 14:38:59 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A548803.000/4gzCSz1KsXz8Xrrb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6AE4F40004
X-Stat-Signature: 5hxaybz66cq4c1a1r73e3dyd8kmrg8rk
X-HE-Tag: 1783924741-476701
X-HE-Meta: U2FsdGVkX1+cZlxoTz1D6+8BftNFZVrSi3vsQZhTrEBa9cnaa8JOTszBZlKWc48IF/xQ9e81461kDXTQIJPiZ/1IQiIdy8qojSrS2yiWAnD2XQxYkvAjEaHI153QJsgRIkrD9iKR8i2feQ6mL200oyEgBDr6cv5HSnN+Xnwcc5gkYI/QzDv8VbnK6uwIkMHlO1KddaZYOF/RiLtN+1L9Ue5ftJU/ZxNejBDhNB0XaRA+ZoB6VDyNjO0y7rG8HoO1eVAgnsovch03qeS+RL0vY5oEZ5NPyKURiD58SSJt/NB0LOi5/mBF1gH59AUASk0AezKjSSuzynabmgwlIB4oc30a9MWzHB/+VuRtVD6gDJUFwSmWwGddhQ0i87x93qlHeYMcHNDws0wE9N4+YtPxG3QT4sLhYmuFeetaRqQ4HgiHcQB0DJeIYLyXtXaPkK1PP/CIJDrGT7gj1lpXaV0v0NwoCoYU+IU3VgGBLfEbiFvH/Ko4yHjT3dihcVV39Y/pWgTPBiniE7Q1IoWTtyIsnELLkvvUayyKS+p7FQpBpzYVm/gXrfDV1LAnevLXZf6ZV+R7dnsvon53Y5Q1LIc6f30y1Ygxnttw12qwZSNh7S9mK0eVLaUOEGnuGdIivUlj0dps3647ex32e1H1mCWMceVYwJ6XgPrxR8Kf+ggbuOv393NcwdlJ/o5BNJYk3qkK+LkVf4K4wg0QB17HHQfC9CWFPihbD7sIhWXBJoDNz4A1ZGqlwKiJyuUR69XkzgHOpFuRhOHxtfGL3E1n0UcdvXo50bF4MeazeObYAHnJjyQTUPF/lFyfKsa0UbUvqwtlLHE4GoQ8novoZabXKZwbeIOD3fdxrqkhFDLYB35vgfktLw25FpEcmSpABIxdhdnjxDkaI04ldnV2mL83eAfzm93DwGjGMusFF3bbPxSzKvfitOyMLaLD4z0DbAP+m+73uhXAGOi3Nprf6FtyFWV
 57WzwXww
 qterPXgOW5imyX42vxOf4YZPVzpehzeC3fTnBK47jW0O4OfwP5/tee3H8RWhqmVtq/l/xhqWpItYID0ClehgPcmQTP7McKFnIairNt20ZSIxV8/Ko7Kov1I2hrKwCGVplwzEEcuGX7iQQkzl2mxFcntsvFMOqG7crtGlZIUau4itjDWvU90iwyx7ZtyoK6JXaP8tGNLtZe662G2KWOEm+jG3qG6+SwST13Ge17fyQaTzmZfswBFTF6dOREPgzd9Lm6pSgT58/JNrAdZKr//t5uaHx4cuVaHMDHeD8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Clean up the names by replacing _foo with foo, and document why they
cannot be static inline.

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

