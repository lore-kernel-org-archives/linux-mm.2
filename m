Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E69DC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4E26B009F; Sat, 12 Sep 2026 15:50:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46FD6B00AD; Sat, 12 Sep 2026 15:50:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0C46B00AE; Sat, 12 Sep 2026 15:50:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0A756B009F
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:50:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E55C1120588
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:50:31 +0000 (UTC)
X-FDA: 85206152262.03.E086018
Received: from mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
	by imf22.hostedemail.com (Postfix) with ESMTP id D406AC0005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:50:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QpZfBJAE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.63 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789242630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7iCdG+EO3//BwprPTeEY4DKPx2D64bP1xkVZGm24v4=;
	b=5UkrtJEmSeyXnObzzNjgCFzFYIiQBmhzpzkzDkggPjjf+zOlcl4p+C/7LEYuzRcF8bVRRc
	U8xQieCDMkwZTE7nGUtRzoN6wQZPAVXWC8hu7QC0M76lzpJdNDPC2pwg63t/Lsr8LJ+/Jz
	HO/MyTwpIcLA7eykZmjze+dBDFJWiyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789242630;
	b=IPuuIKwlSuWHlGSq9Vlw6uwXZhmLQ09arYYPRwmnuh2EZ4zcfXvh8+503dWDOyq78h63nA
	t5nsvw08Foh1OJ2tL0sKV7X3l2AKCqdaida8yLSH4mZ6XMnsFEllZF2KnfacZ1N4rZON7y
	6FvnufYhId/2gM43uL1rKq0rnybXZ/g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QpZfBJAE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.63 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=brsh5b/KdMNuvnx+9fqsxBmZ2yLtLLwkoZhQRJDHq64=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789242626; v=1; x=1789847426;
 b=QpZfBJAE//lAjKLaME4jfm+6uKFx+MLqPu3UOV/yX10W4gAWZ85MeRGoWTBuPxs2VQ7txOXw
 QNiW9mxNGf8DzqKZKLgc8aba/uWVTlP1PxW7wtKRrqTkPATBAZZ0mUdYYMo1JxhdLLFivSwVUUl
 YkNlwS4zDxoGlTmnrttcyXmw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 0fc06f63615bcd41;
	Sat, 12 Sep 2026 19:50:26 +0000
X-Mizu-Trace-ID: 0fc06f63615bcd41
X-Migadu-Flow: FLOW_OUT
From: Ilya Gladyshev <ilya.gladyshev@linux.dev>
To: ilya.gladyshev@linux.dev
Cc: akpm@linux-foundation.org,
	andrew+netdev@lunn.ch,
	apopple@nvidia.com,
	artem.kuzin@huawei.com,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	Liam.Howlett@oracle.com,
	edumazet@google.com,
	harry.yoo@oracle.com,
	hramamurthy@google.com,
	ivgorbunov@me.com,
	joshwash@google.com,
	kirill@shutemov.name,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	torvalds@linuxfoundation.org,
	vbabka@suse.cz,
	willy@infradead.org,
	yuzhao@google.com,
	ziy@nvidia.com
Subject: [PATCH v6 1/3] gve: reduce pagecnt_bias to USHRT_MAX
Date: Sat, 12 Sep 2026 22:50:08 +0300
Message-ID: <7d7dc5d62597f2f76ed890a3056e9754ede1c54d.1789239015.git.ilya.gladyshev@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789239015.git.ilya.gladyshev@linux.dev>
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D406AC0005
X-Stat-Signature: u4rsumsh73f4ohwu78uhtdrzmxtzcxhx
X-HE-Tag: 1789242629-422000
X-HE-Meta: U2FsdGVkX1/s6LiRqDgauUCBszeDF8AmphZnZGUSZdg+8TrLGehpaRs5Ah/RppmdxtP4PVryvWU79vUf9t1Ib9JgHl07WAn3jRkgqSPyDgfJJPfc1DiXW0TsQ8e8p4uJ1BnoM+5Ky2R1IQGnov+nuRVt/IYuvudj9pcaKaUDxJKX/Z5gAPjX/NwICRszpYIwXui398Pcxw+ZxLlaFlLnOzebWFUphvXfJoKC1Y4HcZAjFkYwnhDd0an6B4ETcMsy66j/j/YS9L2yQxDsLaM0DDbpEOlDuxnyYbHU7W04Z3wTn1HTbWWnZm7wkMHZsPfAbFIurUG54FL9EgmsNFdqw5gwEeGgkHIoebXlEX00wfv1C/wI7PqNJr0+QhvQOyH7YcrfknhmGcuQayrxHhMXV17UpxwMQs8vftPBdgfSwjyB6q7HYDjX4C9XrFHrLm2bUUjA9iUADmRDszxedpaUaWXGMmFz4yWOiyAitT5entB0P4O7ZQ/oKzYXQOddfDPq1azBEUllxnyzq2GCgKGjw+mh2q/7FRHFlgrZjtjaeTrdwC4QvxZlZWWUn/ZpptTCQ1hpCol98CAFVEPl6xVRITqQWtu2dX5bQFkHszE3ytKryGh5ICC+GJGtjTgxbDq+c2OLm81LPgcKCX/rn0jg0mnmzrp9m8cQwwRC4UGRxwT1xY71yAMqPf4TxjyNVvG9Zkw38CDGw6QgYNVSeZNkAWm1MVxMLCIwJCDnhkpQIA4HhXTa+ScUlFHz8DqpPh6R004demvXMcHPhW11hDgFg6hmqJh66bK2UnNx+uz4/v1TDp8wmjBfXg/xM/7ZUVoZsOIy++S3NwPMleuSNBiDJ0HI5dt4Qiw8W+f0iDWNVT9FejlVxvIsd080/g4qW6pytQq2oX9LJy3PtmX9JQaSMed0ZTEVjzeDuQrwpiHEZu2nkWHLMiw8VhuO1q1g0Hle89uIR1d/X/4xEs3SqJt
 afSMb0+y
 Cy1daltYjAN/YRPavRA/EXHc7bhMvnuEt/xOylbBpmsFGg5e31wM25dB7CaBrGeiDAETOGZrXFkwBDlnSpecJTmnznFD8qjJP9uIQlS7G8kHfQexhJ7FyLSijhis40DKcJk7X4blvpus5L4oyCzs7hlhBipAVfm/WsNIuHiNPM4RjOXUAEXnNWur7+OlYKh6J3f/+YuetsO1MKAghPfJ0TP2HXWiDhA5N1qjtHSbawi1/w3Qn9ylVzQzqDVZGqG3ej+yFSLlT/Ndgn6FmcZWSMCK8CdvkjwSopOwbpgvZr74pC/mLoLNNiKtDAWRGNTW/3vTV2/GMbc3NaLhdslyVUOvQsJqDYoxWJ5uUqq2nRclpPOuJvGLR0xFpjQEYuybd7TLfhHNg5qmCRwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Google GVE driver bumps page refcount with INT_MAX ghost users instead
of the usual USHRT_MAX like other drivers. This INT_MAX bump brings
refcount dangerously close to an overflow.

This works fine for now, as refcount is treated as unsigned. However,
following patches will reduce the usable range of refcount values,
making signed int overflow critical.

Signed-off-by: Ilya Gladyshev <ilya.gladyshev@linux.dev>
---
 drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c | 4 ++--
 drivers/net/ethernet/google/gve/gve_rx.c              | 8 ++++----
 drivers/net/ethernet/google/gve/gve_utils.c           | 6 +++---
 drivers/net/ethernet/google/gve/gve_utils.h           | 2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c b/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
index 6880d1531ba5..52223baf0303 100644
--- a/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
@@ -149,8 +149,8 @@ int gve_alloc_qpl_page_dqo(struct gve_rx_ring *rx,
 	buf_state->last_single_ref_offset = 0;
 
 	/* The page already has 1 ref. */
-	page_ref_add(buf_state->page_info.page, INT_MAX - 1);
-	buf_state->page_info.pagecnt_bias = INT_MAX;
+	page_ref_add(buf_state->page_info.page, USHRT_MAX - 1);
+	buf_state->page_info.pagecnt_bias = USHRT_MAX;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 81ea800e66e9..3bed19866376 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -152,8 +152,8 @@ static void gve_setup_rx_buffer(struct gve_rx_ring *rx,
 	page_info->buf_size = rx->packet_buffer_size;
 	*slot_addr = cpu_to_be64(addr);
 	/* The page already has 1 ref */
-	page_ref_add(page, INT_MAX - 1);
-	page_info->pagecnt_bias = INT_MAX;
+	page_ref_add(page, USHRT_MAX - 1);
+	page_info->pagecnt_bias = USHRT_MAX;
 }
 
 static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
@@ -230,8 +230,8 @@ static int gve_rx_prefill_pages(struct gve_rx_ring *rx,
 			rx->qpl_copy_pool[j].buf_size = rx->packet_buffer_size;
 
 			/* The page already has 1 ref. */
-			page_ref_add(page, INT_MAX - 1);
-			rx->qpl_copy_pool[j].pagecnt_bias = INT_MAX;
+			page_ref_add(page, USHRT_MAX - 1);
+			rx->qpl_copy_pool[j].pagecnt_bias = USHRT_MAX;
 		}
 	}
 
diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
index b53b7fcdcdaf..267fe3c88553 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -95,13 +95,13 @@ void gve_dec_pagecnt_bias(struct gve_rx_slot_page_info *page_info)
 	if (page_info->pagecnt_bias == 0) {
 		int pagecount = page_count(page_info->page);
 
-		/* If we have run out of bias - set it back up to INT_MAX
+		/* If we have run out of bias - set it back up to USHRT_MAX
 		 * minus the existing refs.
 		 */
-		page_info->pagecnt_bias = INT_MAX - pagecount;
+		page_info->pagecnt_bias = USHRT_MAX - pagecount;
 
 		/* Set pagecount back up to max. */
-		page_ref_add(page_info->page, INT_MAX - pagecount);
+		page_ref_add(page_info->page, USHRT_MAX - pagecount);
 	}
 }
 
diff --git a/drivers/net/ethernet/google/gve/gve_utils.h b/drivers/net/ethernet/google/gve/gve_utils.h
index bf2e9a0adb36..2933453d1a33 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.h
+++ b/drivers/net/ethernet/google/gve/gve_utils.h
@@ -25,7 +25,7 @@ struct sk_buff *gve_rx_copy_data(struct net_device *dev, struct napi_struct *nap
 struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
 			    struct gve_rx_slot_page_info *page_info, u16 len);
 
-/* Decrement pagecnt_bias. Set it back to INT_MAX if it reached zero. */
+/* Decrement pagecnt_bias. Set it back to USHRT_MAX if it reached zero. */
 void gve_dec_pagecnt_bias(struct gve_rx_slot_page_info *page_info);
 
 void gve_add_napi(struct gve_priv *priv, int ntfy_idx,
-- 
2.55.0


