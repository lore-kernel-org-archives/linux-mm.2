Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BD7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7436B0095; Mon, 13 Jul 2026 21:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897926B0096; Mon, 13 Jul 2026 21:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7615C6B0098; Mon, 13 Jul 2026 21:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 437766B0095
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:28:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7D8712023D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:28:25 +0000 (UTC)
X-FDA: 84985646970.14.11C4009
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 586EC120007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:28:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783992503;
	b=yafx0HjwbLTYD9mSFb1rg7GmrfKmfdwEsI6d7czpVwf3x4dKB7araBwb6ap858AY3CMejI
	B9irsBZtagD0L0V86T4kAJmdiNbc7tbRmZxxjdIvgx48H/Zi1CoIlZlVgIeE9ypHdxKb+2
	CclEGWeLNh1JwsxZcte2izcnGaFWxRQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783992503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ksecKoV1m91X877ghp+baDEWFePEaPZQ+S6Q11gltZE=;
	b=GllA6F7uWKJkpdW/GqgnyUDUzScKH+wxr60x3Mqkv8wyMIHcubkYFCfPM7hRqx6NYjuWZZ
	GSatjcgW4zyyEwMo3VXp3n4J6MPqZOmREwVhEPB9L99Gl+7XiKDWdDZCTyF7bjx5s4U9ua
	on+ieWy+Yhm8Mp9kp4yEx4k1gt7mvtQ=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gzhX51XLHz4yjjG;
	Tue, 14 Jul 2026 09:28:21 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 66E1SEBN096313;
	Tue, 14 Jul 2026 09:28:14 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 14 Jul 2026 09:28:15 +0800 (CST)
X-Zmail-TransId: 2af96a5590afcc4-a677d
X-Mailer: Zmail v1.0
Message-ID: <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
In-Reply-To: <202607140924549782dUh3YBPmy8g1NDMK2zIW@zte.com.cn>
References: 202607140924549782dUh3YBPmy8g1NDMK2zIW@zte.com.cn
Date: Tue, 14 Jul 2026 09:28:15 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <wang.yaxin@zte.com.cn>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYzIDIvMl0gbW0vbW1fc2xvdC5oOiBhZGQgY29tbWVudHMgZm9yIG1tX3Nsb3RfbG9va3VwL2luc2VydA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66E1SEBN096313
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 14 Jul 2026 09:28:21 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5590B5.000/4gzhX51XLHz4yjjG
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 586EC120007
X-Stat-Signature: 8eemaoi6rwz31zf8896byumxtzixp8ig
X-HE-Tag: 1783992503-951441
X-HE-Meta: U2FsdGVkX1/+HMkTe4qPMpAv0gMEwizakdraWtWv8fpkoIAsDZwT3Hjvtxq/CC1dKUevfdGSPtGMKYgXG6vC07cwAjD7P0m4T5Z9exMD/mhqWklNm4h3Fi9zeGOgmHLyPPlOWaZca89RLPyB3FHv+j4KjPxc3fGAiIta/9Nnsa0u8AbpD8mS+mLgff7q3NnTNR7jgyBIuTVGlZFMreySeJJ3ui/lgg+Wu5fmENHVhQvGSq4okKkNr+p3p2O20YRhkU0qsC3oYytQLmWE6fvoe8piMps7lseWdyphEPTtFLg2xKG6h/WFmt9a1wPi6/YW4SQnxBzrhNaA2Ga3yxs8wc7AHJzRdGYFAsqhWygN2PzgZEfrUArLzTzsHOrpDjJRg4rM0xrHseOQH5z2m0gQmEEb/iBDAAeYPruG/KVHPZ6aAJ2vs7nYR6KxNB266tMvYLIYrIWOwzhS0FmhAQU/phg7Nj03eA4osTeBuGxm41q/ItBznhymJF2n/m5dtIdOpOhOGx39h3UCazeuLzKPfzzKRXz/OsMNY2g7QagGRfUyhdEBORjAUfuhWOWJu+qbAnYGMsakiTLSyekJwcqG2uaBTMy8Cr+LwnPXw2SXfOb6wea6+o9Y70lFLvqzQpTxpR5jCcFvEyTjJC7y0TG7HMi1EaYYnlEDqsBegM5ydKCc+yyEPmQ3lxI7M397A6QduN0rNGBGEJBpeNf+YH4cG1ZIoUKlbyl2J32/GIoNXGY4FuwiPkcCkd/fScSpxZROQoZYFZceskZFNOHvHgXAZLym0Fixs5ha7ow6xBlmkGrJnoPuqD6y70TI1dDUXv1lmKZJwJgKpBxA+4dsru/PrtaH35yFrANw1STgRvncz1Kyaycx1wCOpvHWvkHtgQPY3zhyuGZ6JxlZLCHpNla/JKjMv7Oe5/ejmSL0TDx+o7PX3sH3lIjGOgdOzIR+adMIv1JmizdjuDbmQwJ9CHh
 mTmJHOX/
 zQDi6RlugW4byPghfvf9lwKHoSCNDNNmhfYbS8+gGQzA2+TRcpN6sFOrLuRTwi9p6/X7cBOe3HPqzEGjlgc7NFuVc7jPWls9UtphUhkcuMsUoEu7ZjL3DZlRk6vi4Vmr6HCxtCT9OFZ/jqKD0IJqq4aPjpDmtCHwhi7yGLxpYg0uP5Gxq/5e6tLz2wROq3e+M+ybdXnszWtysKpbmuWKHaDaTNnvXToGJNU0jpN1cBboGUds3OdKp4w0Iwts1CGw+7vyKuwjK/K/Plxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

mm_slot_lookup() and mm_slot_insert() are the only helpers in
this header that are implemented as macros rather than static inline
functions. This may look inconsistent without explanation.

Explain they must be macros because hash_for_each_possible()
needs the table as an array (for sizeof), not a pointer.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/mm_slot.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mm_slot.h b/mm/mm_slot.h
index 5de3e91d86b4..9b09b68e5742 100644
--- a/mm/mm_slot.h
+++ b/mm/mm_slot.h
@@ -33,6 +33,12 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
 	kmem_cache_free(cache, objp);
 }

+/*
+ * Note: mm_slot_lookup and mm_slot_insert cannot be converted to static inline
+ * functions because the hash helpers (hash_for_each_possible and hash_add) rely
+ * on the actual array argument 'hashtable' for sizeof() instead of pointers.
+ */
+
 #define mm_slot_lookup(_hashtable, _mm) 				       \
 ({									       \
 	struct mm_slot *tmp_slot, *mm_slot = NULL;			       \
-- 
2.25.1

