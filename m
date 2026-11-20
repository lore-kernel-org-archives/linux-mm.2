Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8961606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BEXkTU7B
Received: by kanga.kvack.org (Postfix)
	id ED05A6B06BE; Thu, 19 Nov 2026 20:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7DD6B06C9; Thu, 19 Nov 2026 20:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D704C6B0735; Thu, 19 Nov 2026 20:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC2C46B06BE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 446A91A0CE9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:31 +0000 (UTC)
X-FDA: 85453709502.09.A822F7B
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8333DC000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BEXkTU7B;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3T53_agYKCOYTZQhhWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3T53_agYKCOYTZQhhWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136849;
	b=3uHZ6ruajPrVO3Q6FHMnWe4Ifyq+KzdnoL4H1E+kmAhY4QLiCWljqzmydoQDLD+JrlQqZm
	SuQaGAMtufuTjVSD0geDpqekNxQ1yKCDnGnEBMZpJiY/M1dca+FQz3aGiAe0kyfuSGv7Ff
	AYHh/rIURGhJZ/6igcCW5uCB8S3SplE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXiDLRBLPSFfTPfUoJ5i1Hu7TTvZxwWf2XG5sLJAj+k=;
	b=pa4u8EvDkoX1uecKSRnTNd5GI5C8OI0zM9tapR0SFFFU6QNmht3aLPB1f20ZE/TzXVNSN2
	Yf2PWLEoQIkL/gnIp0BLUf/NnAVmpBziGCF8QPiaeW024EZa4Mq+0/fnb3oEYLo7hRxKyN
	rWANPoLqNDXL8kU1yF+n5zFy1meV93Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BEXkTU7B;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3T53_agYKCOYTZQhhWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3T53_agYKCOYTZQhhWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--lrizzo.bounces.google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b88815d748so342164a12.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136848; x=1795741648; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uXiDLRBLPSFfTPfUoJ5i1Hu7TTvZxwWf2XG5sLJAj+k=;
        b=BEXkTU7BaXnMCHnFF3pc22gpsDHzwWJe1+ZudR8Mc+z70WdXpg7Rl2PWfpwYd/JLJq
         JUjyVp50wQOtGEgUudrplWD92mxTvv8hZ8O/xTHJOwODebuulhC0jPgcitrRwUSJ8vyK
         mGlqN2t33+VYFwpBIUR9zgOt+0QHO9C/BUqgKvrg+2KFVlyOqNxaR6R7TWxmedC3drM5
         BP45mx9Mt3sUQcdEc3cFy+q2H+fPkCsMC5qaOn4p7U/asjiYs9AdQNlEeSImd2mucoYT
         troBCApvYP3ZNJbBW3fWTriSVhVA2nPNa06JTYeMSdvhJq3+/7y/disyh+Gdi0NF3ld9
         jxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136848; x=1795741648;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uXiDLRBLPSFfTPfUoJ5i1Hu7TTvZxwWf2XG5sLJAj+k=;
        b=VsE7Ji7HOo2lC2Cmv+KpULZ8l3tuyx3q6Ilt0hHjibXaxRI4/A1myCmcqBkjzGllI2
         M+hnuGdqYMmIZGlj0cZ3oaaKEql8K3gDsIXtfTkFXNeQxbn63x6vBWbyz4NUo6pOOnat
         7WcOPXide6IGzqEUCAVHMuOGezCADzQdOL4RtwZ9SR+Ih1jpIf1y9uS1fPLEbwzAgXI2
         Z7yU1nQ34usqDXL2+AX0pxhjTchYgqscRJ6taOnRwOREVJ9Rd0CXcn17jMT66Z0Kismk
         9AqVu9TGz6v6Vyd7OLhY+6LquwtOtY2RYUcZNIPdVq2fC1Di7vcDBRE25abOJASEoKGA
         7PFQ==
X-Forwarded-Encrypted: i=1; AL+hErEsoaRdqGL9Oxoh/PcrrqwpZCh/+Qa9z7UhgqShu7NNp68roljxZ6nJJpbPg3CQzEOiFdW+HPvwng==@kvack.org
X-Gm-Message-State: APuU4Z+eWDBKLxwT5lPM8ceKYGrFpQf/exqNpYYmJZzRbbnqMQBoMxki
	mA1+d+61iMeoBHywrKxQT61dbFBpoZu4Xpde3c51d40AeUQg9hfmKQOJ4K02+APtYth/QLkkEha
	6ZGGFkw==
X-Received: from edeg28.prod.google.com ([2002:a05:6402:565c:b0:6b7:8448:c876])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:c522:20b0:6b4:c971:589d
 with SMTP id 4fb4d7f45d1cf-6ba37d640bbmr579772a12.13.1795136847835; Thu, 19
 Nov 2026 17:07:27 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:54 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-25-lrizzo@google.com>
Subject: [RFC PATCH v3 24/25] net/gve: Use PISA memory for RX buffers
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8333DC000D
X-Stat-Signature: z1c6mp49y4uxc1oo5eqk4rx8cfsea38u
X-HE-Tag: 1795136849-716499
X-HE-Meta: U2FsdGVkX18HsshBjSb9mnS3p0MggM9Sj/EsF3ehXhelz8i8G0OJcMZmmRLW1eJXKnZ1e+U7ttb+KHy7pfA33JQa+8n9rLO0Io/uU7dqfLbob1tcul17m8ooLDtzegeEE9rtJRhsf7BCxpDWTBQAaPfzWmKYpZSwWSEe/JrBC7U8GsM2VOOmfxl8kiwRB6aMzy8q9LMwSNW/sxjNsJ8P4LHykgIMleOabp9Mw9DOaWNnxnko3VuP5wfMG1vLPZ9G//UaCvoY8dD0B5kri4fQNASExFiRCj5rS/r2gqGVRXpbuGw7z3uZPRhy0yuUA2fYieScpHBPyPRZLtFoxk6b49lKjavWXvfgVytquAiyHPgBjibFqgR7vMr0bx2yf8vPC+yJwmCORS2n9iOiRP/8cN+dQQE6XnQt3SiUkxuP/JgO0d1GBSYV+MXcH1SvuJuBiLX9rd47X/aUbYRG/ve/dEAch+qfFvffjm6Q6qP/FEDEz7R1w7LI9/W8MybJyS3TWa+Hkeiq8kaOg0lZ+k5JKjmJjLFCfteEfWUVoOOVsPT8/vaOGHxzI2s8vPsAQgYDKTV2MoAM2auZP5RzbgOGK17tuIgzBVk0LnWU14ooLQDStBwqXGGv9yS85NKoTwpp8wbU2l+NfY4zVTQzJp1Hsbpd4XGxBtmco1fS/xQBNXmEuhDUxSeI1/G4dXzubh9W4YIlMNIJ1PbkcHp6sf1z2368B3pfCbY+xEoQn1ICGQjYT9snk4z0suSCllz1zQwLI39Ip+WXxP1e7ef6gSzrkD+wQrmzVTgG5j6lpKZAOMJNdcuoYrt3jD7bH8M03z2WXFiFq60LtNL3lXQ8c6LpcsC0f3bSePaaPEPr8U74TBpoOHuHRoj2l8P8PqKvoFe3HABlvn+ObQlXbL495+1hA50ai6YVoEkgoDW6aKEgEgGdvioweuorCVsQl+8Krb64fWM64S/m00FFgU1lwxt
 Barg/lha
 PZn+mmbdW9xlrAw3+UBxhBaWXp353wYS529tWM+2PizSwudOCuSNy5YpV8nsB3eu6f3pkYFmexKlE6YktoEkrG0AUg94LwAhjEtzQKx6X/FAVfrxZDQPNNiKrWc9FBboKztAPRzoLnbVHUEwujOr5xHkTtixJOWjm1+ImIV9Fq6AXsk3LEciHh+qPWXtfHTOzzTGYeHuFZbsQ462ET9Jrb3IFY4q2vje9604dABt1OuxTSKAwdFBnGDlXQmMDo3x9Z/cSMvBBoFKSICiG7Z97cM0HNfQrJot4g1wY1b5x7Q+2cmXSHSYfQ5mAy9Q1MdLBjf0cNNF1u3xJrCfbSBzBUZ74rF820ZpmS2LSy3LLaG7NUaqUdT+xJ/XCUdL75tCXGh1XAKVmASfbpC/T6pKe/O1CKdu2M02+zb0Y1AOMpBMe2r/Epi4zogNcRPJZrr07Dgg5xawtUG8YV2UA0pJKGvo1u5GXq2KyM5VS78J+xkqXMt4xeNNIYvIxLBBnKkQ3iWUiSXm3N8jRGMUQwpNzkMS6hfA47vKtbUR9MYQbPph6xKQLafjyb0okqUVtbd699C4nRLTa8qexNqcv7ctIIvSYKelntETjR0DVURIdIOZjFRtAyAbwIW/2BuKQJIXucpUkKA7wJta4giXcpN39iPFUMaEGHHsuZfa/+0xDDINh8Tbiw6y6C0d0YKTC0tvpZx4giGIm/3+V7UtnvU4KP6Uqzx+57WmxF56t6Pi/VHYF0lj7UXc8lVY6uFKLqOGv5lVIA8NzoN8tH+iN+HLiCacdPyYjMF5wWdgtZFOgBQvK0XXupMwphFZjiTi1JS/yebFdl4qykLooY6iTy6dYigDKvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When dev->pisa_rx_bufs is enabled, allocate GQI-RDA RX packet buffers
with pisa_rx_gfp(dev) so they come from the per-node PISA
allocator, and evict plain pages when a free PISA RX block is available;
DQO-RDA uses page_pool, which checks dev->pisa_rx_bufs directly.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 34 ++++++++++++++++--------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 7c201fd513ee3..562c11f5bdd24 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2015-2021 Google, Inc.
  */
 
+#include <linux/pisa.h>
 #include "gve.h"
 #include "gve_adminq.h"
 #include "gve_utils.h"
@@ -165,6 +166,8 @@ static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 	dma_addr_t dma;
 	int err;
 
+	if (rx->data.raw_addressing)
+		gfp |= pisa_rx_gfp(dev);
 	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE, gfp);
 	if (err) {
 		u64_stats_update_begin(&rx->statss);
@@ -494,13 +497,19 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *sl
 	*(slot_addr) ^= offset;
 }
 
-static int gve_rx_can_recycle_buffer(struct gve_rx_slot_page_info *page_info)
+static int gve_rx_can_recycle_buffer(struct gve_rx_ring *rx,
+				     struct gve_rx_slot_page_info *page_info)
 {
 	int pagecount = page_count(page_info->page);
 
 	/* This page is not being used by any SKBs - reuse */
-	if (pagecount == page_info->pagecnt_bias)
+	if (pagecount == page_info->pagecnt_bias) {
+		if (rx && rx->data.raw_addressing &&
+		    !is_pisa_page(page_info->page) &&
+		    pisa_has_free_blocks_rx(&rx->gve->pdev->dev, 0, rx->gve->numa_node))
+			return 0;
 		return 1;
+	}
 	/* This page is still being used by an SKB - we can't reuse */
 	else if (pagecount > page_info->pagecnt_bias)
 		return 0;
@@ -544,7 +553,7 @@ static struct sk_buff *gve_rx_copy_to_pool(struct gve_rx_ring *rx,
 
 	copy_page_info = &rx->qpl_copy_pool[pool_idx];
 	if (!copy_page_info->can_flip) {
-		int recycle = gve_rx_can_recycle_buffer(copy_page_info);
+		int recycle = gve_rx_can_recycle_buffer(NULL, copy_page_info);
 
 		if (unlikely(recycle < 0)) {
 			gve_schedule_reset(rx->gve);
@@ -664,7 +673,7 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 			u64_stats_update_end(&rx->statss);
 		}
 	} else {
-		int recycle = gve_rx_can_recycle_buffer(page_info);
+		int recycle = gve_rx_can_recycle_buffer(rx, page_info);
 
 		if (unlikely(recycle < 0)) {
 			gve_schedule_reset(priv);
@@ -970,7 +979,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 			 * owns half the page it is impossible to tell which half. Either
 			 * the whole page is free or it needs to be replaced.
 			 */
-			int recycle = gve_rx_can_recycle_buffer(page_info);
+			int recycle = gve_rx_can_recycle_buffer(rx, page_info);
 
 			if (recycle < 0) {
 				if (!rx->data.raw_addressing)
@@ -982,13 +991,16 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 				union gve_rx_data_slot *data_slot =
 						&rx->data.data_ring[idx];
 				struct device *dev = &priv->pdev->dev;
-				gve_rx_free_buffer(dev, page_info, data_slot);
-				page_info->page = NULL;
-				if (gve_rx_alloc_buffer(priv, dev, page_info,
-							data_slot, rx,
-							GFP_ATOMIC)) {
+				struct gve_rx_slot_page_info new_info = {};
+				union gve_rx_data_slot new_slot;
+
+				if (gve_rx_alloc_buffer(priv, dev, &new_info,
+							&new_slot, rx,
+							GFP_ATOMIC))
 					break;
-				}
+				gve_rx_free_buffer(dev, page_info, data_slot);
+				*page_info = new_info;
+				*data_slot = new_slot;
 			}
 		}
 		fill_cnt++;
-- 
2.56.1.809.ga0b61035b5-goog


