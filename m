Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2901ACD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 18:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674846B008A; Tue,  2 Jun 2026 14:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6258A6B008C; Tue,  2 Jun 2026 14:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0216B0092; Tue,  2 Jun 2026 14:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1246B008A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:31:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E54CFA09A7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:31:45 +0000 (UTC)
X-FDA: 84835816170.01.F4E1662
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id DAC8D180013
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:31:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780425104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L02qb+fc41ni9ojRFQLpdYce6kkEH1h9fkjAxArua80=;
	b=mQIx6WoFoFzo+0JKVrdHiZmNgH6W5IeW67Zc3rThJ3hAaHSgE+F1Q57ACxFamukkxhXRvi
	T9YgdlUP0eNpR//5I8dI83wSieqOdhKst6p6MPbYXvSL93Jg5Fo67nsDFS2m39Y1RdvoY0
	zCKL79xOOmqvGTKzewt3NlIyEArSdKI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780425104;
	b=BSqfcykmPNwgKKiR+2msl6RqId/np0vbElRHWShbWcO8sl/tSmKpVqoswuBwxsPkDtt+RV
	GC+hv5OSL2Z4Yp5n6mG511lYgUXpDh6Kse31scIIwU4noKwstdaN75Z+0+QDcLGtlcIsDd
	9Z8mg0RE+10K84nYJDQAnA+5pFdH4Co=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BCF2366FF6;
	Tue,  2 Jun 2026 18:31:42 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 72292779A7;
	Tue,  2 Jun 2026 18:31:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QFZMGI0hH2owXQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 18:31:41 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH 1/2] mm/slab: add a node-track-caller variant for kmem buckets allocation
Date: Tue,  2 Jun 2026 19:31:21 +0100
Message-ID: <20260602183122.747759-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602183122.747759-1-pfalcato@suse.de>
References: <20260602183122.747759-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 76exm5s7sjkqenat8q85bdqj3qeq7txw
X-Rspamd-Queue-Id: DAC8D180013
X-HE-Tag: 1780425103-906325
X-HE-Meta: U2FsdGVkX18d5jh7/YMgddz0uUmKkCXdWKsLru49tKswboQZM8GAmjWWou/rkjLU0jnfxNVlKQczJw4seBygjM9SCdzJxRwWxctXT03rb4ke+MYO/VCHcuKZaFO9YnxLUPGqzK8VXNxofTYnAg2Oma7lCbNY9MZU86T3lXAyLgFYpOc/fUCXQstUAlRObT7dEEMwlgFTIiRSd3lTzaxTnvBDEaCKpWeF9khRQf0GhP5H7daWiGmOL4wLHc4bKWhLxm1MrrFfYPI4qMT9ftPsCUwfWRI84ChWiTx/m3e6KP4iePGywu2JYp6sZ3+CFppgmK8S6r6jhzgFF59HaT7EnZMbAORVnCB6GjiQ3YQZ6lPvsU7VneiqK0uunucnXFNVM3YkFqqroovcckiP/5rVj91nvG0QR+qWqM+DPVU1TLrvqjkB05KdkNmBTFitZLAodGAQWCAFb92Ei5680AXxkkD3xdZfdYw18fVe1YWRB8JxNv3p8RkEZEWF0su2BjU6N/qmvwcUNEEwJ4kltnUE4BFZEObeWtyDkDKfLTiKRvJm5FyirevQ5Py4sgPiGwNn3pB5q6CY75/nPwAaIioZmHI138c/5z0GBSeVID0PjRqu1/H49Ik0hOA2K0nRHENuMKMwx+3Yg92y0ijCdc6hIYI/ddb3OzKmZLl8Sj/y/RX3/v4IWPeFiJDIWV3EC+0eQ6Asl/W7xx+1peL12OIAV4cRK0kjJvOkbDDhDwRhWnRViLTzvRTXrdgGXxDYa7G7/WMOVw2odW60wanJHV+wdlUH5LzyJ67XurU8Fr6+QTFk6d5YwbvpZLras0Cs6JNKAxa3F2/BVHC/qtXMfhJPYqtfZ50ltq5xu0lSSuVinfqogX9vybW+caeRAIi2JTwu7e5aEBlFahTJ+c9+y5LcNX6p5VbgkO+vJn3Cir7HQ+ui8IB/PaC29OfPus/UiXnsoW3cJObZY4NSpiv5JCd
 36goTRRh
 vpkBZzGZePhTe0VU9m0Ar52iowxWXkyDR54egtD6/azF2XINU1pO2A7+oOHlf5SkoYqb58/l6HHGHb7012LBFM6yA/UxPHVjL9xUj9U/zm34cXNHNACzK9tsg+E9wCvUbskkprATjWyA8chp0ibpcpy2IIqIHeoNPR4j4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is required by users that want to use kmem buckets, but still
desire specifying the NUMA node.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 include/linux/slab.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 7b46fa499b08..685a87d8f0c5 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1153,8 +1153,11 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
 #define kmem_buckets_alloc(_b, _size, _flags)	\
 	alloc_hooks(__kmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, NUMA_NO_NODE))
 
-#define kmem_buckets_alloc_track_caller(_b, _size, _flags)	\
-	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, NUMA_NO_NODE, _RET_IP_))
+#define kmem_buckets_alloc_node_track_caller(_b, _size, _flags, _node)	\
+	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, _node, _RET_IP_))
+
+#define kmem_buckets_alloc_track_caller(_b, _size, _flags) \
+	kmem_buckets_alloc_node_track_caller(_b, _size, _flags, NUMA_NO_NODE)
 
 static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, gfp_t flags, int node, kmalloc_token_t token)
 {
-- 
2.54.0


