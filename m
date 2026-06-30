Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15DD8C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39F16B00D7; Tue, 30 Jun 2026 07:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEACD6B00D9; Tue, 30 Jun 2026 07:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27C26B00DA; Tue, 30 Jun 2026 07:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B46196B00D7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:00:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F8334045E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:00:00 +0000 (UTC)
X-FDA: 84936284160.02.774119B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 936AF160006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+l60L7w;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817198;
	b=imSOChhc0n3bjkVCdWqMURslpl3/LwEBMSd9rB3pSPAPD4os8C4gmEsj7hU/RcQkQ86F4L
	xistIumXcIRgfOkUoM3Iqa9AsqfLpHdS6cvEQx6zcrrZni4UjzhEgQewObuxYRew8CSnhb
	vIcHAVz13t6qRjvijFQMnhA8nZRgOP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uoX4qX+FZWfnshgsq0X7cWNdSoKNRRVi845f4JIWs1M=;
	b=FLvC/Xe2EAb5Ptu773YaUlaxw9ETHZTZvC9e/iCNSWNOSyFM0R6uUyarphyKru3ZriH74d
	2henNo+lXAaJO6y0kbKVDKpEM9Iebd5kkmLeDziWphui1L0jJt/e/lkMSKoS2KE66Kna9E
	UOV2xYn5/oPBIeRTCzlI40M84++DnrE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+l60L7w;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 371AA600FC;
	Tue, 30 Jun 2026 10:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617C81F00A3F;
	Tue, 30 Jun 2026 10:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817197;
	bh=uoX4qX+FZWfnshgsq0X7cWNdSoKNRRVi845f4JIWs1M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z+l60L7wn/PShGQKOVf1uhUaR8+VJHm56bmboZldAjfa5+rWFzL+mzZyxkjjooadV
	 wsf1HlrnDhCLt1VCQhMO057gNkL4/ki0eS/5OYX9/9ZwvhGEhpKb29+Gm8Remz6d1B
	 Rmw9MS+PDoCRERuT8V6DQMMADlSyqJGDnomFNnSdgDlNF3cRw5cFcdPMrzAFDKnEAH
	 0XRtlJyBXyq0BuiKqcIxChmIVmPvNkYVA6aM/GsMSFtH6N7RDP/AuEG4GPSkJoO8uY
	 mpbzYCwoD5Pw010DnINlP+QgJtqiDzrYGbzBGVg3vPImYTt0vDejn1AmTXPB2q2pgb
	 nqljjBe2Hkszg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:25 +0300
Subject: [PATCH net-next 6/8] sfc/siena: use kmalloc() to allocate logging
 buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-6-672162a91f37@kernel.org>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 936AF160006
X-Stat-Signature: dxcq1o8676x1nom8oktykhwsrc1j5qp8
X-HE-Tag: 1782817198-877650
X-HE-Meta: U2FsdGVkX1+rLz7fxVeB/OKXjJoz0incWgHshQYAkrWwjDhEeFAhseZO932DdEF0lK6PM95DaVTaUpGo+ZAjBtCmitV+SOr2qfwsK7mauJlFSO2HqeB6iRt2HpefOCNbb8FylEMyFtDe4Kq6Pei4i7aDmnBe394VT8XnJKsAKnjZv4+qlXfplXi4amNlAzF/wMHUmYR9L22jcgnZ2r8NJB1jPLlfqXtkwnrfgp+rvMqhP58GQyF0hATvpeuzWHaBzybgS+nUqWUUboCHYaORXs2bKSpw2JBEky6gUms7Le8c/pt66CuhtHCzYd0qVmSz+Agf7fANCgWHBQinfZp1Zlkwf/lNpI2YcBVarTz5j+9hWL3+1MupnxBO9jzAZWl5am33sFMj8ipZEKyVu2Ouy2n8V0T7Oxs+V06KdVn5k3E3TSDdSX2C8miB/VzGyI7uHYGp79yx8R4a7n7/SBajY6gg06gcFxCb+Gu9RamEiXDENO4Hk4sQ1xPo2Q3KjzPzz6eyKe2r36cBpk4CDfizVauPTN9A3Mz1EoTlbmXYHPgWX68ndakr78C6Bd4DQc0DPzIvVkJAhONFZUrOqRO51Y+Q7kDN/VoEv2KqMJXc8ILgF9unlScsI+IX/osKRFH2Ih9MFG6gz2GJv1KeYlwr47nzODtlXcMeWaA5lK7t7P01VUa8AhR4JxMFHBijAmyZlA6zN/HBYdWdo9q1/MB1B46FUXHS3wj79hZsEI6kVAEE7p9ctscFGmBEsWHHqsUWu7eT7gTWDLomGp4Rrnb/esN0ZNiuSAWLW3cboBL32f9iNF1Uz20uVIZQMQ+5HjfLkhdHIDPyoW1q3fgEsyRIuEyJ6VoPwzVWdPIIy4CHNmmZ5LT1s+kcDTnEKv87N3eS5xZ1YLSecoSvi4bV2S+aRwAwwwM+vf+idYRmhKHtiH60uVU5HJS7jBOZHzl5sPkC1uFjf5spSb+3Fd+UHpm
 JVH29yHO
 snTwjOsmNVIqzucWq1PwSkTZE95D8W2M6VfFQdqOc8SHN6FkA7JNtfSYoBl5ldbpmUWlCfIfTKrJwkbBD0X8gQsi3OJp/uHZFp15jlOKuj6oRACuNBOKAqD7kKsO0LvlS0cjx6XNViAgJp0X7SKMRAdfNP2PLFv1FZBZ4bf+M4mQnlrYyddyUPqXt1D5Dx+lxvyEqzdOjACo9BKvL2vsMMU/llPT8MrQb5P8SQrLgHKTCaVaoD6u31HsrKGiE5Y2ff+YtM+2aKXavj+5W6H9dLw7lspoh2MFBE6cHAg3F0l6Bfjrfmwx/wYzOQiLdRaDqoff8fj2dYlNpjyly8PYR3KvmB8+QnenXri0I16lLwHJf5e4gkYvDjpENi52wgASNnD3p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

efx_siena_mcdi_init() allocates a logging buffer for MCDI firmware
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
 drivers/net/ethernet/sfc/siena/mcdi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index 4d0d6bd5d3d1..048c1e6017c0 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -7,6 +7,7 @@
 #include <linux/delay.h>
 #include <linux/moduleparam.h>
 #include <linux/atomic.h>
+#include <linux/slab.h>
 #include "net_driver.h"
 #include "nic.h"
 #include "io.h"
@@ -73,7 +74,7 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
 	mcdi->efx = efx;
 #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	/* consuming code assumes buffer is page-sized */
-	mcdi->logging_buffer = (char *)__get_free_page(GFP_KERNEL);
+	mcdi->logging_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!mcdi->logging_buffer)
 		goto fail1;
 	mcdi->logging_enabled = efx_siena_mcdi_logging_default;
@@ -116,7 +117,7 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
 	return 0;
 fail2:
 #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
-	free_page((unsigned long)mcdi->logging_buffer);
+	kfree(mcdi->logging_buffer);
 fail1:
 #endif
 	kfree(efx->mcdi);
@@ -142,7 +143,7 @@ void efx_siena_mcdi_fini(struct efx_nic *efx)
 		return;
 
 #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
-	free_page((unsigned long)efx->mcdi->iface.logging_buffer);
+	kfree(efx->mcdi->iface.logging_buffer);
 #endif
 
 	kfree(efx->mcdi);

-- 
2.53.0


