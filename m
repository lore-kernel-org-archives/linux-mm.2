Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B3C606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VsFh5745
Received: by kanga.kvack.org (Postfix)
	id C112F6B0617; Thu, 19 Nov 2026 20:07:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE89F6B069C; Thu, 19 Nov 2026 20:07:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD88A6B06BE; Thu, 19 Nov 2026 20:07:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2A76B0617
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04ECB120CD4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:29 +0000 (UTC)
X-FDA: 85453709460.29.90373DA
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf11.hostedemail.com (Postfix) with ESMTP id 464F940005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=VsFh5745;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3Tp3_agYKCOUSYPggVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3Tp3_agYKCOUSYPggVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136848;
	b=k8f6C6zUlblqUpQ0HFO55mw1vrlxD+N2bM2VPh4auA2F6kOKKG03Y3L0pLgn86zx0SrQpm
	fiIpA4v8Ehg0gPZWn2djoVwK/+VL3LBCWrtkyEmntnodQRuP4KmKgiLBo/f52BjHIvmY2j
	rueVM0LI/1BEaoAEDc1hTyBuYJJb5TA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E07+bb3FRwBQVv7TP6tKUfjd8V3oXYxVPDexh6Cqmzk=;
	b=DnEd3IvlJVdJmSdaoTdY4CFZyodccoPAE/9yPnr+/J++DAh9iglb5PCawuy6bHUmkVzWMx
	eZu6Rk9Gduy2CPlCI/1PpiVsXQvUbLYhJ/SjkT8ZWPLBIwgumI9DroIhoEHCnLeiDg7z4+
	ehBO8MxI0riwZwDDcuu3sYTs+qm3IPs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=VsFh5745;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3Tp3_agYKCOUSYPggVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3Tp3_agYKCOUSYPggVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--lrizzo.bounces.google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b85c9f9af9so352182a12.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136847; x=1795741647; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E07+bb3FRwBQVv7TP6tKUfjd8V3oXYxVPDexh6Cqmzk=;
        b=VsFh5745kttUcOXKU61FifsHgyJw+7WKBdXu8hQ+Mh40K+hPzbuACctu5XUlnRk+Xz
         qVTAA6NYiOK2OgOJoLQltYMXx91P4kVqyN546JTH8/8XCk31siL1k3eOGI0yK+LBU+3f
         WTwaBTb322kBoe5/kqDJMcNsAfR3z8TwnlKv+M/wXkFrArnuRokHhELXwxO/dPHJmNBb
         H1zWSC3DvJp07Ak3Ub5XHSsVkYDDUqdLtUdpoghJYNMpbTPM+hEe9iDIjECmghfFMvw6
         v+WGNCHSI49imqKuhKW4Fn2qRMq7S5eSlGGVpfBkgU3V/B2eZ01h3s91VD7nUZ/M4mWn
         7Ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136847; x=1795741647;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E07+bb3FRwBQVv7TP6tKUfjd8V3oXYxVPDexh6Cqmzk=;
        b=R6AVkxKIhXjEBx/orqgbv6f4blwA56WMBkILP/sSMCmjeeDbZrQZs+McITSG81H0IE
         whrng0WQxxr3EqkegiHTI9HN4V8ONz2IwAPO/Oa1hEvnN0U70dMZoIHMLaupZl/d6ssI
         Gt97TtAO7FmBG1I5n4mhdZ336sIH13b3NNKSAjpBL5vT+1P8RTU5U2s47eoaVFR7h6ec
         ttY0y96BVfP4SBZ8hCDIe9NEYFIcLQQfXoETp5v752LBAgQzk5ovPYNs5BMt3knnNcno
         L7GAPcowWMQWyITH91u2cOZleN+rVnHTHrsWYYg2hoYGcjFYqqX0wY+qyM3324fpvjfx
         Zumg==
X-Forwarded-Encrypted: i=1; AL+hErG2Y2Sd8WiC8zi0rz8Ww7bd5bM7w+/+QVvgo91VbG9Gp6mSu0y54zLZ2ByhbZirTkCEb7A6Vxu6Ig==@kvack.org
X-Gm-Message-State: APuU4Z9IcWGAZlEkzSIYH+reASdEDawtE8pCA9ZdI5bgqb7gvITZoD9E
	OER8E482gToOFENt3HXC727PVwsmt0g7440F+Efps7filQdxl+I0TNGtU59x8/hBQ42gOgTcNix
	f9FYKTQ==
X-Received: from edl2-n1.prod.google.com ([2002:a05:6402:4242:10b0:6b5:6602:7fc9])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1e94:b0:6b5:8247:7bc7
 with SMTP id 4fb4d7f45d1cf-6ba37ed4f03mr808156a12.44.1795136846496; Thu, 19
 Nov 2026 17:07:26 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:53 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-24-lrizzo@google.com>
Subject: [RFC PATCH v3 23/25] net/gve: Use GFP_KERNEL when pre-filling RX rings
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 464F940005
X-Stat-Signature: cgcgaeyqy9cxotstwbmri5w3wpfgmoy4
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795136848-645205
X-HE-Meta: U2FsdGVkX19hDE4bkdd3sCcJftUzCXywBa+oloKJ/nEHfSsyAnGib+G6ZI3HYDlLUPYoDRDRQfpXunve4+Vwlpe7PzE1LZKz0d1t/c5AfOQr2QB/WIZN8aI1v+/vSE0BFdjKsLwy3tvERIAxCXXjR1xwuqUfumNhcFSvVxidjnNzTPWh81VKKEfeIQdUTPY2IlgIepFjxZn7o8k4zfTAZJ42KC0zl6I3wW6wObMt6wH4SPw9vea+nNuVGTQ8jfciUsyRLvaIG3xIb8I77JbNgjGh0huyADaJDzKXAEm8cubs8O7Odpho9pZA7LIWabxkz5TWEB/uBiXuP6ZbiOvcUMoCYPihkBn4/idMnbQTUr+fNkGKtgzcO1XrPWj0X5et5uDhlcLt9BhypEhmxlGvIUYRomt3ve4h55AF4OJB2IyCxOnji3x+2GelHDtkykrAvqh757lQrkcPQXJqxDEJStacpal1TUN6kLaihnVR79qFLoou2wgL2EsMuMelJQ9henoNHgS8elI5Ip7rM7/HilKw7kAJ+H9n4BsLTxsy+dfw5Goq1HGX1wpRXwaWQy+njCkeQzC5nzUAtPv9uvc0vykQcGgbDwbfrkWvy6Q+IRGelx6ICzte0vqyZQSZy2kl0HK3AjDPo6mI7u4PgN7d6SU+MwIzyQ5YZmCwhcPgJzz2ad7IOwGY8IpR/pCGwtlGFe3DbARjowG1wibjAvsFQb+5EahjsElKb11JLQMTuE7rbi4cXr2KjgyD/IYIBvVMnwDjlZL8tpLbUVtAVlkGybDnDgQisaw4pjkPrQSaR9AvKjxzs39Rai90RbS6IQP7AwyB85skkRjyxVVIfG+9hYgaPZxVSME0Gx7H482hCbw88KCJDn7tkw2rWHhf27m2pV5QaEr8MlDFAYn1Ii6PyjUHeydvMmwrS1QwyoSf+mckPPUl/UxD7pnsfb9e7aIFOP4weiPhGrCinGw6hen
 NGen4Bcc
 v7aDXU8N/68hL25ftpaLDyari9qiU/YB75XqWS4fLPB+EZc1IBW+P3wcd0L/vUcxEe1xsE85vIah6my5iJEDfO+FsP8VcawR8rkN/dye7sMm7ExwfIJ+I4SFWkrd0djMZLk+FqPibnx6BglkAFwDF1nKMOiImv+H/QGBKUldTaLz6vZmgzne3b4rdnwoaVt8fQa4reaOEzTK4qVsOyYWOvcDm5E0dBH+aBfxYzIy4ZxK9cAPW4bvj8+X6rpTy0FGKYvni+/ugA5ORjraxe0CHCQd81vmFnU8VoDXsBcia1RGG1g9Q+0wE6zzuKcvUjs865aprrAZ11L6uLIa1L7Hp6/6FxAGhLUvI1w9jD95nUfHp9qeXwyVxQRzYcu7SN1VYvCv45PIYm9WmJW1L16CiArs+ZyC8W5MhBdtkW4sW3vqapnlur3a3mxD7JM+Qrz2GhGLo2N3/yVhQMdh97w2S9A/2Wc++31/7GY9/OgHWGr+MtGosfiz/nc8Pw/XL4jiC0MRaac2yNdoWY5z16GW92oTgUiQWqBR+DgJKawgwooZCmg82+cpDeaJFs/aJGTshTUk5d8qACLIhPDOQnIvGKMSbqTLZVGobNrZT7FapOPlESPlJHgn0tecIIRb7zREIuf3DMgib6qGsNwUcGSNNWsG2zWxPRYXX1DUguGiSzHGM/RXL3Tt/YAYELFjuBrQ94VNFgtUL+dHrrZ06+Av91ewOMgjuaKh45KV5SJRUXcyhlx2brLYlMoBNAPTJk9w51hGBBVd7kEB7bOvbE+jGj+VJ9KGhvRR1E2aTzjYRHi1Fl0KnIUjXkfM42VXGGvGH560jI//BkLNEUb5Ar9M2JG8lJaPJavkQ/Rsgyy/aOwMVV+ThTqWXCgVnhWqn7c/71LZ5
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
 drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c |  8 +++++++-
 drivers/net/ethernet/google/gve/gve_rx.c              | 10 +++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c b/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
index 6880d1531ba5e..a3fe684ca087a 100644
--- a/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
@@ -223,13 +223,19 @@ void gve_free_to_page_pool(struct gve_rx_ring *rx,
 static int gve_alloc_from_page_pool(struct gve_rx_ring *rx,
 				    struct gve_rx_buf_state_dqo *buf_state)
 {
+	/*
+	 * Use GFP_KERNEL when pre-filling RX rings in process context (e.g.
+	 * gve_open) so PISA metadata init and CoCo page decryption can sleep.
+	 */
+	gfp_t gfp = (gve_get_napi_enabled(rx->gve) || in_softirq()) ?
+		    GFP_ATOMIC : GFP_KERNEL;
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
index 81ea800e66e94..7c201fd513ee3 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -159,14 +159,13 @@ static void gve_setup_rx_buffer(struct gve_rx_ring *rx,
 static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 			       struct gve_rx_slot_page_info *page_info,
 			       union gve_rx_data_slot *data_slot,
-			       struct gve_rx_ring *rx)
+			       struct gve_rx_ring *rx, gfp_t gfp)
 {
 	struct page *page;
 	dma_addr_t dma;
 	int err;
 
-	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE,
-			     GFP_ATOMIC);
+	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE, gfp);
 	if (err) {
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_buf_alloc_fail++;
@@ -209,7 +208,7 @@ static int gve_rx_prefill_pages(struct gve_rx_ring *rx,
 		}
 		err = gve_rx_alloc_buffer(priv, &priv->pdev->dev,
 					  &rx->data.page_info[i],
-					  &rx->data.data_ring[i], rx);
+					  &rx->data.data_ring[i], rx, GFP_KERNEL);
 		if (err)
 			goto alloc_err_rda;
 	}
@@ -986,7 +985,8 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 				gve_rx_free_buffer(dev, page_info, data_slot);
 				page_info->page = NULL;
 				if (gve_rx_alloc_buffer(priv, dev, page_info,
-							data_slot, rx)) {
+							data_slot, rx,
+							GFP_ATOMIC)) {
 					break;
 				}
 			}
-- 
2.56.1.809.ga0b61035b5-goog


