Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DC2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE706B00AE; Wed,  1 Jul 2026 09:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795F06B00AF; Wed,  1 Jul 2026 09:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3456B00B0; Wed,  1 Jul 2026 09:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 492726B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:57:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C223AA039F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:42 +0000 (UTC)
X-FDA: 84940360764.30.36C4CFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id ECBC518000F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjiUo+I1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914261;
	b=iA1dRzmYw8L//7LL3WFow8jCoQ5QlVh1yR1wVyvI6bELf51m6XdesR3uGH/avnnRJRbL4U
	Yp/6IAg5h8tcOmCSwW9GxujZyhtMqgHM19mpVjz2e2NTNG7fZksu1SUIwQct8MzEcgXzwg
	OqD34xczr0goPgtohMULXH6/PIrMky4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVNG6A0QrvVc3Q5VGETu2ZNN6OFwwV/HGShrasBWJk4=;
	b=BjcQ9DOQDFVf49LwIihw82eoFvNAYDjXJy8/yNJHBtM7Jf0bhMZjV/cLDRyAoBew54Ct/G
	B//njB6gqpYSpKemuURdAkkl2fyNwMQZ9n8+Drtn0U4Tg9ncjC3HU2Gcd+DIPI4cExQ+B2
	BmPef1vzZuxEfuvv5zC8eUMz6d4w02A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjiUo+I1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42CCA4022F;
	Wed,  1 Jul 2026 13:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB66B1F00A3A;
	Wed,  1 Jul 2026 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914260;
	bh=qVNG6A0QrvVc3Q5VGETu2ZNN6OFwwV/HGShrasBWJk4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JjiUo+I1MUHxEgU3cQbZI86Y6WHaDCOxBbtbySGtgnRUKHqnTTFt5JN/+yZbEvPqb
	 BhROnNLTi+nMcez+8v1Nto6/1KuUqnMd3qAXMJe2sqM8PayfcKz0sjU9kLPVgKUl7g
	 zvtzpJwqFk+YJo/2kc6qaz+Cr8TE47gB8TD7KbFle63Z/yJvJeh61z7zwar0G+jPIp
	 bVXz0dHzWlX0v/ImjFLGHVpGMuKGgVPJyGugLUOiKm34jrgQaMQyUftl0SDvVjkXbb
	 4wdni/3VNT2ldqBHT7XKnGSXy7AZ0k0+OLvP1JJn8yHLXktr+nMzN81mcn1K3TyjPH
	 ayilUm7MHnf9A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 16:57:21 +0300
Subject: [PATCH 4/4] sfc: use kmalloc() to allocate logging buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-drivers-ethernet-v1-4-58776615db6e@kernel.org>
References: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
In-Reply-To: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Manish Chopra <manishc@marvell.com>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, Mike Rapoport <rppt@kernel.org>, 
 intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-net-drivers@amd.com, netdev@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECBC518000F
X-Stat-Signature: zr91jnsg4tamkac4oipipr6eoucmp9x6
X-HE-Tag: 1782914260-137991
X-HE-Meta: U2FsdGVkX1+6J/Ez4wQjUABZFLyNHENmvu1M54U6qA6IV3yb2fHWKaLenLANoa3tt+JQdztxSBLVEumEd5J6/fSTUrr37Ql+zepDyiblm0bSQI1lK0kaZOx3zvwHEiLNnBWo4M1CIfXTE8O0dOz+l31GLPgY1ULxuobBPUwxIYcZq2A5fPHXvYdU1u2JcOEVCm1B6vyinlk485k9KTrU9694a6594QEmy7yIDLRqeOgaibR6Kg+wdibVrpcGHeKRyqB8b7qdg4lgskBTjHbyJVpuf+6LEBH+0arpS+q2fkTqiRVCqIkdBWNmBFdHmldqJqX9JuLbqt6igvpP/yiXyVFYLyyFzWgPuLGVGcP6+sqnzLB/LIDAliYr8Pb0CtdSR8v5awBZVTYtxtid7cvJ1KKmt/udATlimBvdMmVlKEPPDV7+rgAhge7VYrvPtGUwZJnEV3jkXPIk1XD5ujcFKs4Ai7tKXx+n1qAEr5ocAryz+iBreWPOW/LzdOpSPZ2XdyF0OkNkWAzojuJnKSKZ30la3/64alIjV3R6cte0mQYUD9GSr0dyvBIuF+z4WPMaNXGRAZ7kXOvzF3HJpw96vFPAo0hiPTRGYs2xPw3oS/CWr3y0z7ze+c3odP9xym4tWoAI7Rn/qDq009SlLm4CpjnoiCOduHC9KYEbK9NZrecyog1crpaKDWossMoWmnTDaQKUMvFKpuTdfoAk8dEIKoWjojjd2kKgAgjS2Ig5tlk0esfUTielAkKN9KOWg9Am5iuQWFQUnR4nWGpnHy6lqM97GcLQAQLa+9v5TR0ah8qUwRgZNbuqOhFfwftglwetOfxk1oNUYwbuU3vETDIuq72mgkv/dBdxw1+rrEyM4I/e1Uv7X568JeolB3JEw/m3KC+FacrMnrHfNdHW5Z945AXOE5mXT6EmVa+SNhKojxfVeP4w+fjb4dhVFVg1BeM6wtN3Ys1EixVzXH1i7vf
 WivbEAg1
 LqhswK1Z23EuSa3jOnWVlJHoqRDJ6tpD0KncDUZvJOUwm8PU8aIFNBlwVbyyJLNqy4mU+7r0NASxmsLLDqH+X6SDvyg4d53xJggTnNdhCOg9CVEJPj/HRpSOm/XbTLFdjuj/SRSF94+4ry15Yoer4GX4kTh81SPeBJhSQ+ZKdvL/1DUcOjy8FL+4A70Pkzj1fi2U3pZkX1HV2Y3aHHGN2Srezm8fvyIXdFGTqaFDSQMXwlz9KPJjHRD4sBGl6seJiyFGZVp+n0XxNe/ZQNcYzhsTMPoXfqXGNXh9S1mdtChJYIdK9qwwpoUQ426GtJQA0GvAvmv7TC+vwoHOD8Kyca0VSa20BBIv8Ls1SyyYBcsZxCaO2INwJipkIFwbgkaYf6/HQ
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


