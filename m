Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BA2C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D9D6B00D9; Tue, 30 Jun 2026 07:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574E36B00DB; Tue, 30 Jun 2026 07:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3226B00DC; Tue, 30 Jun 2026 07:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2456B00D9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:00:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8372616806A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:00:05 +0000 (UTC)
X-FDA: 84936284370.15.5E75111
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C0B9140004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:00:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMVGaWI9;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817203;
	b=5gKRISWZGqU8UIgCH0QGfzmU1W+OulU42qDYS8GrMXF89rA1Y02Jjuker0a0vCWczBg7ej
	TaRMuj2d45kUkHhUNWKWVWI7cxNTJT39cReGgobYK5+98RKFWQpNOd0SJgl3n8Ey+crNh1
	LZhcRBrdzOjkn+c10fM4X59VLzavSrI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVNG6A0QrvVc3Q5VGETu2ZNN6OFwwV/HGShrasBWJk4=;
	b=jAk5K5wS2Yoqk7jpUb0gcq/6EatBzzqjB40Ac+0hvWjI0GVYD+n/79S7Up8tUStbYQW7NR
	++csL6ac4J5p7NfdcgNZg93eQwHP5nCRF5KSUzrMMy/0/8GofMOFoma1vb0LhH69Xxf8mv
	Yx4GILsspKilPSOFONlxyxYZNcKebrM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMVGaWI9;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1412840E06;
	Tue, 30 Jun 2026 11:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1A51F000E9;
	Tue, 30 Jun 2026 10:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817203;
	bh=qVNG6A0QrvVc3Q5VGETu2ZNN6OFwwV/HGShrasBWJk4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZMVGaWI9VL4Ex4gSsvHRdpL8r28sBJeHwMEuL7+lauPlew2FTdOEsgs2ATl1+atca
	 5LYGcr4dixAyl65dQrx1zaB/Glfflj9NCXAqVLtCfj8sE2er5nqspknawJYfva0Chv
	 vKRhkeVapVUnpfeuyh4J75IHXPeUUpy5UPveQh5Llp1phBnJX8oYOScCnmkcIBSI6q
	 EkJvpcSINDcZQKSJ/otkSjIulmeOQfuTzYU9nqou8/TxgPQebt/GjHstOjzw9cPTO7
	 WUMbUxdHMl15cDSi+gs3tI/IEI0Ne+cwtcQB5Ilb6oLY2SCNlfdksJjYyFL7tCxlDT
	 rQgDawk1deirQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:26 +0300
Subject: [PATCH net-next 7/8] sfc: use kmalloc() to allocate logging buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-7-672162a91f37@kernel.org>
References: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
In-Reply-To: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Edward Cree <ecree.xilinx@gmail.com>, 
 Francesco Dolcini <francesco@dolcini.it>, 
 Manish Chopra <manishc@marvell.com>, Mike Rapoport <rppt@kernel.org>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, b43-dev@lists.infradead.org, 
 intel-wired-lan@lists.osuosl.org, libertas-dev@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-net-drivers@amd.com, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0B9140004
X-Stat-Signature: 8p4ksw715sjm7ma89ceggx71s6gky4pd
X-HE-Tag: 1782817203-680140
X-HE-Meta: U2FsdGVkX1/wP0mgfZGBprRROdpTOuQWUfql1CkJDxX20Sz1wq8oar8qpMcN2pocrOnPfMvjC9hlk4ixPtMC4RkK78lXVkUkKb8nI8Cijngtgh05fIw68x6fUqdb/KuS3lXEtG3nVWE+OgXgyLuFPBMyzltkec6OZLvJA6oNgXrDi1ydFiUEQg02euSOeD1asBz1XpKYqqQdOnqdAPpEnPlaM67GqjWZikxwk1Oy9eYBET2tk71b0dZjuxOLr+znINheXvOiG8qdJ7ay1W7wMtEdNlr+hwb1MJj1jXG6SmtdtKaWi6Ttv4ewdRwhoIaEPAE8FPpkJfU1UTqpp8KOaBHyjFbU5ePJtLV7UQ19g3zVKnEmVyl2gYws2/VBM72bL9h62iv7JsiY1MWGksWeDcer54hz8V7rY9ViAC8molLelT/JsxnWkgBIY59Hrs9EEkw2IKUfRVrs8IrLyU5uyJ0D5zPzff3NyHSAHA57TspSifJ/d7ZXMa+E4rr48ZsAsMeXV0nLmSz8qXveMUx1fkGeeBRViAbDEeu2fkom1MP4kbauHLadGoclCD97YXJdcTLen6Vdpy3ZV9Eg4bqsNeFmiWdp63daodgx01MSMxrP8f7jmuntFXAr2dcbycpgHQph63nAwMG6Pb86O6ysGDE9qP5Vp+9bxoygyblWBt5O4G7OYy3fN1gH5RUeOn2gMxDj9YIgWEoC7H0bvHf9Ta+iKzU2e2DWBhecJLAXzrCYIjKQghfHVBBNLU4TCSgStm8DX8U5+zKvdJ+wXljr2VanST1+vDsu5PnEiMacbt/Cv5LGcYQmVIZLT5cKEiD85x81f64hv4JuThdKxsZVv3RrFipmMrJ3dOLEdhCQRWtGaVdYYKXRTSEAgfOPqcCOmB0Es0+5B/+eDuurURjsUygnECdfEfzyAJP/NS0oGH3YAnq8OrZY2BkyGLJwIAZ5wIQcDSJwh6CmerR/9mr
 dXIGRVeP
 MGxTeHfYS7hNuUBe4OFakUy522JJVZxVflxHPuq+ErqMXt6HmkCMnCmMWpyzbCc47Uq07lBOYaALagu8LW5oF9l9ncDBG8VPWR5XVuUvoTDf+rFNqv0KsdExKyF7oZpAYjNxjSa2rGja9sYhiSXOt694cUZW7Y/Vq0ui9uqCMrmyskRL95VWl3M0M28P2WSonOY/zAWrHBtf7y8cx8r988tO49rPeQRfjPkxMnAqEfxhssJAQJVyMRVX/j1vwrlsTWYEUtUm36gG5hEQGMIKJzXjSy+M8F26Bir852xQu0mk6l48iK4bf1urcDfXPnJBebe+IG54Djj3TzAJgG+EOf/1efEmHHhiDPpfzsxNz5M31a+uHkkG529Hf63Oiwf52eT32
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

efx_mcdi_init() allocates a logging buffer for MCDI firmware
communication diagnostics.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/ethernet/sfc/mcdi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index e65db9b70724..b806d3d90c42 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -7,6 +7,7 @@
 #include <linux/delay.h>
 #include <linux/moduleparam.h>
 #include <linux/atomic.h>
+#include <linux/slab.h>
 #include "net_driver.h"
 #include "nic.h"
 #include "io.h"
@@ -71,7 +72,7 @@ int efx_mcdi_init(struct efx_nic *efx)
 	mcdi->efx = efx;
 #ifdef CONFIG_SFC_MCDI_LOGGING
 	/* consuming code assumes buffer is page-sized */
-	mcdi->logging_buffer = (char *)__get_free_page(GFP_KERNEL);
+	mcdi->logging_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!mcdi->logging_buffer)
 		goto fail1;
 	mcdi->logging_enabled = mcdi_logging_default;
@@ -112,7 +113,7 @@ int efx_mcdi_init(struct efx_nic *efx)
 	return 0;
 fail2:
 #ifdef CONFIG_SFC_MCDI_LOGGING
-	free_page((unsigned long)mcdi->logging_buffer);
+	kfree(mcdi->logging_buffer);
 fail1:
 #endif
 	kfree(efx->mcdi);
@@ -138,7 +139,7 @@ void efx_mcdi_fini(struct efx_nic *efx)
 		return;
 
 #ifdef CONFIG_SFC_MCDI_LOGGING
-	free_page((unsigned long)efx->mcdi->iface.logging_buffer);
+	kfree(efx->mcdi->iface.logging_buffer);
 #endif
 
 	kfree(efx->mcdi);

-- 
2.53.0


