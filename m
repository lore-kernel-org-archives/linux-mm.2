Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57173C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489F36B00AD; Wed,  1 Jul 2026 09:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 414006B00AE; Wed,  1 Jul 2026 09:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350D46B00AF; Wed,  1 Jul 2026 09:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD4A6B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:57:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AD041A03B4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:38 +0000 (UTC)
X-FDA: 84940360596.08.515066E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0AE6A0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:57:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFCVs9Fj;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914256;
	b=HZIUyKbumShkOgN/cQlmAUhoKiTVN3T2iFL8VnYbiAZ7UiW5QMAddMaQEBkUI804B6k1q/
	8MKa9PM3qVIso/gWISuoG92o/XC3lJtaIXIiB/kZ4f49GWe4BxPAR/GLZTupTwg8kExrv8
	QZ2cboooy2udYXEcIONCV9VK7VD3UVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uoX4qX+FZWfnshgsq0X7cWNdSoKNRRVi845f4JIWs1M=;
	b=7AgYMRP7WQvVEEOrOaK/iwhtNo09NmaFtr7B04767sUkrNUkl7CUz/QXWi8zO9jOR7NFw/
	Rj93qup/L28S6E1ae3WFTvDRCM3f8AtHOF+rmfNGbXnyZRsnXCRXDLhDa/v4KXZ27CCwsU
	y8lZdT8E9f6DWfIQos20V2vSv6r6ajc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFCVs9Fj;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7988860138;
	Wed,  1 Jul 2026 13:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B746A1F000E9;
	Wed,  1 Jul 2026 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914256;
	bh=uoX4qX+FZWfnshgsq0X7cWNdSoKNRRVi845f4JIWs1M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DFCVs9FjGzaRNSAa2f1a1h0gJPO6FRHEot1s1/+N8MLtefzZWzIPhNKXXNKTvI0QC
	 5i4vtEYjUXS4y/9Z9spQOWdu1/iHPVMy+U4g4UKmRKo3ZVDp1Mr9VFjcdnWpizoUkS
	 wwF1EWJXRIOsybH/gLAnfi5cXiAzGlOSH14EHsW12x3/fDSU2/iKsPeIDwHWaxrFFn
	 /y6+C+DfA5q3hC9MxayMQGBR925K6WFRY/mlm7BZxj6D+tYhJZaw4s6uv7cRe+0uof
	 DjqJiWCO1FJviCUXX1KEo4+CXbONILVJ0mFUWq7anN40+86ZhsSjVraOJnMtkkcQos
	 myAlArQhMpOjQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 16:57:20 +0300
Subject: [PATCH 3/4] sfc/siena: use kmalloc() to allocate logging buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-drivers-ethernet-v1-3-58776615db6e@kernel.org>
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
X-Rspamd-Queue-Id: D0AE6A0004
X-Stat-Signature: ocyebfdna1dyrppbrjzpyepf1r84i55u
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782914256-78107
X-HE-Meta: U2FsdGVkX18W0JfcvRlv4z8w8mUE3/cpgjgij4FbN9+fTrheWmBnSTydV+xX947rJ+7OKfDqcjocsp+cXJJbRwCLzB9ZGwVcpRQPAMELIXrnc+SHOyoQSbuASCJ1/f3DnuRS7LuBFWNGPVlZEsXae+zdzJiEBvhcONHm1WVfLn9XpESOzphcfmsrSye2qRisVPtWBsG6xK1M6+MBxtQQDT4U7R+M2PC3uO1O6ETo+yMP5V7SJcQqf4/uo9H7WP8A/z1q4lHGMDr4vlHTzTjUV3L9tIwdmphS5mUZIwyEa1l13jujjXq6lvxBRU3TDzRdfZHmuC3yGMo2KzKS063QbNDTDysIjELIOp/PhR4U/Ee/ibRd8B1M77k5plwV5hCXTmd97T9Qa4q6/Nr5kqlykFitIQGLvXbETrWy432rs+E4qsVJaMkE+rttI9mjLsBHSR7TsPeItHRiSHNNhtlC27lVjbunPYrd/XJOGaARU42P0sQDtxQy/dB4X+PDXJqy2Z776l/9LeaoijODZPNGDHg5tCwSrHsdtojm3BFj+bjpy6u8RM76H9tlYi9yCCX8mAOzhr2bLntoEyxFEG+vYtiDda1YqN/t7vWT27cypmDRSbxXF3seriv9Rzs0csdYum+MgIqC9Uz5aBFV3+HVEvX/ym0Xn0Uq1j7w/JUIVJkRNdzlPafQ4k6F0c4spga2KX17rKGJV3NvQ5l513QhQpbZhDIBTUBklRV8aZhXMHrFeGeD1/GYeqaiU4MyIJSulECoQ4ynEsvdiJSuHErj7trT64r6DIXIo47vlncXpAAeu32qVaB878GMkiYjyw0Oacw16Nf8z0Qq+UtdkADVvmqTW/IKtjqn/57Jy0tLfe/0IFo6hPat90yVUGvRUlQao+QYavUO4QNlwKpyLNB2Yn1ARr82Rly+rybPnGNz2WQdWf6BvS/gjrQiNXz9Lw5SN6zysU0aj9GD9hIugeC
 I4SjVmGk
 uZL+utqTuy7SzZyBw454cXQOMCpO9TMm5oNPOsh9Llbm9NnkNsC3FnNKkyRv8GPdtakrOK0WLJfrJND32OV7BLM1LjYvVCtRT1f5gtqVe54co6HUjTWUtvVfpC8ARfVVVl4DLQg7xPLuijFWeMAg+bShNDae9NRI2ukYky7p+j5ql1U/7mNTlvJlLbZUBhne4BbexYlkG0bFc215jf+rA1wX306Tc2J55p39RqVZxvgLY6ISbZfhJ4/dU/im8WXFHQiqQltZmcUWGzHDUTBzV6bcxxkJlAoLFBfbUXizUyNcZ5h9bTGZ58thxLW8ThLaw42nMWpopMKqyT827JJcFi9CSAuQia9lH5v4IUe6JAvMCtIPH0HU8eoAOCZQC0yVQ9kui
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


