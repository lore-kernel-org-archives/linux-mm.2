Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C029CF2588
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881B76B00A1; Wed, 19 Nov 2025 02:32:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831546B00A2; Wed, 19 Nov 2025 02:32:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FFA6B00A3; Wed, 19 Nov 2025 02:32:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE786B00A1
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:32:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0360A12EF59
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:32:43 +0000 (UTC)
X-FDA: 84126539448.12.5D77944
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5145AA0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:32:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vbucHj67;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1iNplE99sGAypoCEEPI8YVyyZSSPtGtkqVo740CsVs=;
	b=ZwFvB5SQ6PcuFkadRRX6asY5cFZwIA/ZXDT6+PEqKN+Vj1rwcvLN4HfvqLn45xIc1bJKLq
	1vLHiRgCkMruKEitVC4uHZMVbquNugA55igRS0hsyO1bV8IELB8qWs5lvRV3u+AWHud8bL
	7qW5A0xeXjAltxy0onTU/eY63QqIra8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vbucHj67;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763537562; a=rsa-sha256;
	cv=none;
	b=zbpa8SQyli5vuZ7EUAXj4G+MRyCiPl4Qzjlq9+ZAbbMygUDWBoWiF7og4ojiqtH2gJYboc
	EslfiqZ62GafsqSwn80GM9WpMQjnBU6vqkVA1AcuNSljNlWQAzDs9W8yAfTo5BtjPbRAcT
	2ZQHNQFPnGDHmeG9UQEFp6YslMoI0zs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763537560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x1iNplE99sGAypoCEEPI8YVyyZSSPtGtkqVo740CsVs=;
	b=vbucHj67nP76kiXE1QyY8BDwAzCLOGQUCC0PuxiMX09JuvuPEDA7TD6Faql30bLUhiVf76
	IOCfwQsCxOzvk1jJIx6cB/4wVYkH1Ymgi7/nv/RuHvh3YJEurHzaNl8B/s41J5hlfHjpnD
	Wr8XalvYuqFraXJCvIIVSZfyHo2LYco=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ioworker0@gmail.com,
	linmag7@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 1/7] mm: change mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h
Date: Wed, 19 Nov 2025 15:31:18 +0800
Message-ID: <e9d510106b5bf72a9b577b8c5ad161fd3c29c2b6.1763537007.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763537007.git.zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5145AA0005
X-Stat-Signature: grwzsk4pi6mjxzciot39rhstkd1f8g69
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763537562-855835
X-HE-Meta: U2FsdGVkX19muwcKfkmG+qFr7A29keTMNzuaH4Hfl0ivXH2abYNqUOJ5IEvXr/5j+oOarAippznJS2ppRt6cFcGlrtavXglTwtEc37lSaFlsobbPIxJZoF0bl/N9uNYVIJTl7U5liZ2gr5HG+PESXBxENJme/dJ8D89zHvoHVtfVDqXQyjxyYF3IlGXTAjZRTP1hARi8mpmLOlpKGGYFRC6mYpR33qYDVRcJv8aGbsfeFE/moGj3BJjpbJqX95ove9Tlt0yh7GttTDfAE2Xk+BpHQBLrMqYQmApQDmN5c3QjTftzHRDES625cGH9N0Jwy9txZTmjAY+expYEmtpsaKoSj+zuumaLIAtlJt7GSLjYvgrnIjAuoPZa7aj4AoHLw1VYEGI+rT2SEEnfTnpIaaTv1YTAdeSGNRFf4UzJ4rTL0Y9HZilrJmHCyQo80bAZMgzyIvwXbIcY1A8eofT+phT5LV3rs/gsiFE5jVAXda6n9frftL0IKFagu2bNp4josG89UaEFpu2ur7wCEDMvLzrxQfXdBdt8I+RkZ44SA81UHEjC4vWibZ+yT0DBYx9x0mqsWdYOr21v9/R3a2QXPb4jR0orHsoldC9l9DuMIjLPmXBHcvaopkwnists2Nqj0PYfqrcmez0AY4BbNexoX8vv2DTcZTEyflopvH7/J6R/xG/OEa4KYBYdVR3FvznZti2CsWyzjXJVXcZxtGeY1SnLVUmCEKpV0WRj6w0wWLPE3TCKPqvWukQEFmQtDCzTByfTbYC0EFt9/QRuwWRVWFoB5Q0dgDhf/9R9yU9UwfOPTG6F4QmXLqvhljtjonuYuqIpeNzJrjQ2Jf3ZG6paQLTzYdYFwKb4oLECIQ1ETvBLIdWqkf4WXTbaN5GRKL+ytdUAh0zB8zEDHYOrzpYecAKUtfg3G1pBkLbG+P1amlJKDiLVQ8mH9qBmHJRE7Q8XfTYkRlgXLa2gTuXYbSp
 SyKqcjK+
 A6mGIi96AlFMUE8oGH5MCTKD1LBiu5yiHP3U1n/rZpIDdmlow98MU6ipnIgsaOks1xYEURh07XKhRDJDAx7i85s18b7uuKM562+cqdUhNjDVIAM0ARxQt8z4q58RF5761Rj0TiXMvBGsZfkPKiOwo7G5Fng5kTS+WolcgLCW0ggp+Cmbx/qfk6lcXV69A3mZSJSr3eTCErmsyG6ngmSELniXQE34fT6mug8iHXeM/4sE5qZlUNqFvzjjbluinwaFqZh9clI169L8gLQyKqWgicgJe46EXOJuzPBPLBbP6iEKOlQ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Generally, the asm/tlb.h will include asm-generic/tlb.h, so change
mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h. This can
also fix compilation errors on some architecture when CONFIG_PT_RECLAIM
is enabled (such as alpha).

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/pt_reclaim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
index 0d9cfbf4fe5d8..46771cfff8239 100644
--- a/mm/pt_reclaim.c
+++ b/mm/pt_reclaim.c
@@ -2,7 +2,7 @@
 #include <linux/hugetlb.h>
 #include <linux/pgalloc.h>
 
-#include <asm-generic/tlb.h>
+#include <asm/tlb.h>
 
 #include "internal.h"
 
-- 
2.20.1


