Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F180606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n37sYyMQ
Received: by kanga.kvack.org (Postfix)
	id 46B506B05C9; Mon,  9 Nov 2026 13:26:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE336B05CA; Mon,  9 Nov 2026 13:26:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295CF6B05CB; Mon,  9 Nov 2026 13:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9E2B6B05C9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:26:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5EF7C0767
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:26:01 +0000 (UTC)
X-FDA: 85416409722.12.4F1EF3D
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C39E1A0008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:26:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n37sYyMQ;
	spf=pass (imf19.hostedemail.com: domain of 3NhDyagYKCH0msj00phpphmf.dpnmjovy-nnlwbdl.psh@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3NhDyagYKCH0msj00phpphmf.dpnmjovy-nnlwbdl.psh@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwEhXQGhncgxAenLKf9FgZtSttnofeN4/QkcfEPx9jk=;
	b=eXlWWEZi6xEsqKp4DpeHbwaXBlZrxHH2I7UZpaAHfShLoRE5VQfJNvBhyqBaPjcCP+iwy4
	Nn7QJVB+BZn2NI8r/g08eG92MQXjwTbAFO1DUZUpIMI97UfeYbqDt2JpYgvA475QBxrfPf
	N3Im9yIx9c1IoMdO5/65+UGSvvpZ6OE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248760;
	b=RI0qrUg9BDDyCzxoZgga4zPtEZjy6wsA97uyvoYSaeuCvinb2cPWHu/r7sWt/BuIDPsGAp
	GHJHg/WFwCqj2549pCOMMP03aDbbJ/8cu7Iu7b5DwT4Fqbht8ZJ9ueAIu03N2KtSdWNtTO
	t92P8j9SdOTbqJrrA4/8aKryJ0zlcZ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n37sYyMQ;
	spf=pass (imf19.hostedemail.com: domain of 3NhDyagYKCH0msj00phpphmf.dpnmjovy-nnlwbdl.psh@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3NhDyagYKCH0msj00phpphmf.dpnmjovy-nnlwbdl.psh@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c293e604f0eso114725266b.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248759; x=1794853559; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QwEhXQGhncgxAenLKf9FgZtSttnofeN4/QkcfEPx9jk=;
        b=n37sYyMQa521Xz6vKIk359nIDMjXMxRJyb199fuLu1zEouMxPv0hfiBJ+exfKo7Z0i
         IXiTQm6fv9fCcSIpIVC/x7UAG24+j1i7KzB+3LDzoT2vc/4mIVE7lJnPCJ8L/DSszURO
         BR1iEjV1WJRVyaNZXs052TrESBaN8NscuWH7i++HjsAUN27neAy727KrnbZfqbb8OSxr
         3s92XnxeSQJ09SLEgXa55t74vMKc+K8CVlhdZ4IEAypI1YXMmZ1tNkF7YLMuSPtI7usm
         ZKYmgLKDPaEGLyyg8g0THfVv5WeM/XYaweUuZe74StK7bsP90zlckE7zFi6JsjoShwZk
         B+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248759; x=1794853559;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QwEhXQGhncgxAenLKf9FgZtSttnofeN4/QkcfEPx9jk=;
        b=qJ7/Jqd6rKbsLc+pxGtqcCRONAiOFVuTubHyOJxdDEX/kDUcmZm1ag/wNHrGvv3Rho
         KXQIABywKudzl14SEuRi0noTzmRyUyHToVMplZxQJvB1twukoiZO/wmip6eRz/HNuWnH
         Zz2kTFTcKbXjFhhR7DamDe1IcV3gECjBxc/7DepZZHL9VT/DPHLrpOaM9FdX6xz/j5Nn
         Etx1ISqqCbKLE54K6qadKkZG/G4RPtLO8/a1G8Ouk1w6rF0OXzGCi2BjzYyTc/nzYOKg
         6WIRmGGP5mjs9HSgyK6rPD9tWBlMQSqLokqoLI4IAwRdwnyme1akPXQAiD1srbZNV8Q6
         fTyw==
X-Forwarded-Encrypted: i=1; AL+hErGNnU4y2i8YeRyyUrVfVxahOMK+RptoyKZXm+JR3LONFf5yaMnpmE8ICCipWa/k/IVg6zsxFlwvdg==@kvack.org
X-Gm-Message-State: APuU4Z9FkKTU/7dzlCdfSh5aA+zo7pcpiz9X5ZctJfMYtqKzUHWKfXUt
	asUro0ftk1wOuA58NT1XpQ7yqXD3mmBb+nA0MsVsD3G9+XWzC9CI1JMt4o8ehpIvFNC7OsqqvjI
	DFuzXGA==
X-Received: from ejcxk8.prod.google.com ([2002:a17:907:d808:b0:c4d:1c8b:9299])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:2f06:b0:c41:5e31:5184
 with SMTP id a640c23a62f3a-c504951eb65mr12737766b.13.1794248758596; Mon, 09
 Nov 2026 10:25:58 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:29 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-22-lrizzo@google.com>
Subject: [RFC PATCH v2 21/25] net/gve: Use GFP_KERNEL when pre-filling RX rings
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: e7bg1zije66iz1judeu1xfzcifiod556
X-Rspamd-Queue-Id: 1C39E1A0008
X-Rspam-User: 
X-HE-Tag: 1794248759-278769
X-HE-Meta: U2FsdGVkX19aRqjTI9YH5QOS1rIkfsK5rbJgqd971vCywUxSLLlW6CogHW0YI6IKSBwCoEPJRS/wCkyVJUhj/4bHMPMPYLNE9DxLf2vodwMweONO2om/atk3myYiHNmkmGehESYe7YJqwHH9pTgTxFYcH8fhAlbpEHaKyGVl2muz9f2y86zOEm81B4GbVzKrVMOdS9uVKm4tfBHJU0xiAwJBY+ToR45xiCY5aiEaIFfKkEcclh94rXshbu05a93U0/ADzA6g9gPb6q0ruwuAjYUdypPRCUUigK2p91yNXRYyrXXi3syM0ueuRgqSGvD+9lWs8EcGoknx2aTOifhqoPJqRl7eQNh0m6Dw7OqUHDmA2EXdQ+sIK73XSiATsA158J8r7p+p1avYLR514UNpvMsTspzzRkQNB3taJtL13Eyb8hff1Rk71vm/K1/j8J7ry24muX1ahcJVHhOzs0Jigy4i2Iju6iJRqg7M7gXOSRDkyJKFS2Ris+0FhFEwj2GpU8hTyWu58bYsnBWnqE3W0EtpyZ6AzAWDQ8/NEsB2psupH4DyT0v4Pz42s49gTTh7smgrUJqEO1aZ+KEQsbU4ujNjr1LmTILgbYM6Day3a3ckgVLXU/Ak72lJ7HURdV6ygpMiVb8aYnUk16XyTW1i7mgZx3Nsaggl5i1BRHoECgeKFSRFz0TpTTDZUThqM5vwCoHBk7Lr4j/zY2tqKwwG0r7qMtIj3cyu21luW6WxpP6KlDw83Ru87TTZS3mTPXhmMbc9IU3fnpuETa7sGByYv7m3Dowt48KIUB9QWmQUqYRsVqJwinuA+D9QOI//Pjgqbis0Hkv3rNKQwao4U8UWl/cV4PaGFVxtLpJMDdBKoBVDBwaSBpQGsjqtBHGoKV5xVhVK0/yduOPxVni8mM+7HxVTFPj1K1qAUlaG7QnLXxU9Y5G8V4RTmgwTdemTpBp9Iq04QJcUErr7cWkSHm1
 JWPxbZVO
 nEqzeOZJWdIFdTc3nOZgp6W1qi8oAweMFMYMfEqq5tUGCOwENeiK2GkmzYCZqa4t0tD21fOyxauzmJJ0xyt7OsMc7C2nwMKkA0hEAMt9HqQsBZY/kyFCHtSek/GfOCFHkygveDImUVorEFOtzggHBqOR8Mq7c7knYbZJTHom100C0cxWeAmtNmP8Q9/Q48p5d1a4k5hlwtvauhUcD03NMn+lRuTSw8rjNgBE5wPt0kTm32M330lyOaj6g2cypdZ4+hMTN+xpH5sdxn7Xq7JSho+PGbwqNmBng2WZ9QoVPPRyMNa5R/NtnLIBw7ApuX1qj99oBDhg/gVsHHGc+l4BoIiaoCqGA/becNtoc8S+2bTXPrFUHhGNftQDpao/w0rYE/8jzfi1eatLie2vAe/L89vRQ3/V3Rj3XxeK+cvVnMATMSN/FD978CGm6v+zT/1VVhByMXJ3tPd8ve8EkyS89eFxbXW3TNJIjNUbR0z2zTNsCd6wkcuId0t3grZDlLlI0OGod9x9huVG2Mtm4yxP7+3Tknr4hMWA6Z7nN5EMSqFfzEWCz3KlCaUrfWw3FtFzHaTP9r0KKCM8okECskQO253kZYPiQHGt6LrMtMwQmhRWs1gXwSu90g40oNLaJ3bAjpF3pXB9pjfxvhcocTZ9/3RBTur9TKiiFoLaH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When pre-filling DQO and GQI RX rings in process context before NAPI is
enabled (e.g. gve_open), use GFP_KERNEL instead of GFP_ATOMIC so page
allocation (and CoCo page decryption) can sleep instead of dipping into
atomic reserves.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c | 7 ++++++-
 drivers/net/ethernet/google/gve/gve_rx.c              | 8 ++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c b/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
index 6880d1531ba5e..3b13aa4999ae5 100644
--- a/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
@@ -223,13 +223,18 @@ void gve_free_to_page_pool(struct gve_rx_ring *rx,
 static int gve_alloc_from_page_pool(struct gve_rx_ring *rx,
 				    struct gve_rx_buf_state_dqo *buf_state)
 {
+	/*
+	 * Use GFP_KERNEL when pre-filling RX rings in process context (e.g.
+	 * gve_open) so PISA metadata init and CoCo page decryption can sleep.
+	 */
+	gfp_t gfp = gve_get_napi_enabled(rx->gve) ? GFP_ATOMIC : GFP_KERNEL;
 	netmem_ref netmem;
 
 	buf_state->page_info.buf_size = rx->packet_buffer_truesize;
 	netmem = page_pool_alloc_netmem(rx->dqo.page_pool,
 					&buf_state->page_info.page_offset,
 					&buf_state->page_info.buf_size,
-					GFP_ATOMIC);
+					gfp);
 
 	if (!netmem)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 81ea800e66e94..89f287b678bf0 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -161,12 +161,16 @@ static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 			       union gve_rx_data_slot *data_slot,
 			       struct gve_rx_ring *rx)
 {
+	/*
+	 * Use GFP_KERNEL when pre-filling RX rings in process context (e.g.
+	 * gve_open) so PISA metadata init and CoCo page decryption can sleep.
+	 */
+	gfp_t gfp = gve_get_napi_enabled(priv) ? GFP_ATOMIC : GFP_KERNEL;
 	struct page *page;
 	dma_addr_t dma;
 	int err;
 
-	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE,
-			     GFP_ATOMIC);
+	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE, gfp);
 	if (err) {
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_buf_alloc_fail++;
-- 
2.56.0.542.g3ef89b7020-goog


