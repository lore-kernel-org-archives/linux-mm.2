Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87802606A8BE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fNGYio+K
Received: by kanga.kvack.org (Postfix)
	id 478336B05B4; Wed, 11 Nov 2026 06:08:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404066B05B5; Wed, 11 Nov 2026 06:08:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3412D6B05B6; Wed, 11 Nov 2026 06:08:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 131226B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:08:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 942A3160291
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:29 +0000 (UTC)
X-FDA: 85422564738.21.2E16A67
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	by imf26.hostedemail.com (Postfix) with ESMTP id DBB1114000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fNGYio+K;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3qUz0agoKCHIlTeddUVehjWeeWbU.SecbYdkn-ccalQSa.ehW@flex--vdonnefort.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3qUz0agoKCHIlTeddUVehjWeeWbU.SecbYdkn-ccalQSa.ehW@flex--vdonnefort.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9e5fiKyui+gLN6NGnueZPdNy7gU/9XjTaWNkCYpwsg=;
	b=ScNWBprzkw3Usv3v2U2ipUymWH6kGOSW8pB4JrwyYdsp2glV5lOwc+Zw8VMoP4hJgv/uBV
	y9/putKxnFOKmsqJc3/q93imtx59FVFPvVWoWkOfLSiJ90KT7fInjRJUKWkl17DDC9Rbto
	1v9teytMbeQrybVAMoRumexNcn1kw6w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395308;
	b=WFK+QiqnBGtz6HcYGPFjCN+MtRR+x5XGlJUOUSS3tdRIbMSqVXObUC24VK6qKt7vpdGuSS
	gbbYdECtX9TTPIkL5WtXhE/ZN2eMdLXM+OoRDTSugrplyXEhCgvs198OwqVYWZ3SYLZghY
	qSYgv6MSqXjykRTm5t+CZBtZD63+ZLE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fNGYio+K;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3qUz0agoKCHIlTeddUVehjWeeWbU.SecbYdkn-ccalQSa.ehW@flex--vdonnefort.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3qUz0agoKCHIlTeddUVehjWeeWbU.SecbYdkn-ccalQSa.ehW@flex--vdonnefort.bounces.google.com
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48e4d1e29f3so2932967f8f.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794395306; x=1795000106; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t9e5fiKyui+gLN6NGnueZPdNy7gU/9XjTaWNkCYpwsg=;
        b=fNGYio+K+c+Y30SRFIkHfIlMXp9vqVHAfzI92Rlwt3/XwG9IA5uhGctIp8FSYO5LpK
         kilSM3VhYFR1ihFl4TvIb36J8yJmqew7G71sB1TFB/0un+BN7qam57TOpx+Miv5Ue8KP
         3BR9pZWLZTRWuMpGazMQSr7F6fJrX9wGyWlrMbiXgqIpLJ3Mhrq2+7840IK4E5WUNkvg
         Y2w/mHBnh0fc3MjK1b0jQdX9HHuqAmmczPyx8WP3sty7PrG8dApiHJQKGyUEqGG6y5T9
         Se261k3qtynOUPF9prWVCsEBojguII1ijsegTaIjW1MQoBwpDhYaRMoYH9xZj7FYpbsI
         O1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395306; x=1795000106;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t9e5fiKyui+gLN6NGnueZPdNy7gU/9XjTaWNkCYpwsg=;
        b=UdSuE7cGK2Ue8AYhh+1AEkTtOM/r9l9c+f6/cD8QSqdE6r7Q9cUM/ZPWC5eXVbTu2J
         TOayeS0Vpo50uM2DfMP3zaSZu66Pk4ngTuMSoyNBANcWi/HdM7fp8tauJScZFrRBs6i/
         QE3lVMSOwLBJd6zUHycXNkSYOmo7y+4mvK+/BoY28cH4u4ZoPuTICxXb0hatynIjFh+j
         tCYQc81azbcEmttdt0h0Vv4uCg0bXtgm5zattu6KbYO7TPIfPUQ9pNmgaQ3nhZA3LtuT
         P5Ryf3R+g5R6USN7FQvWKNd+QBTGqGJxcv+p84E8fK0XZKY1TcS3jEFc6B+7yecNvRn6
         Wtgw==
X-Forwarded-Encrypted: i=1; AL+hErGb3HA4hygMc9GX4H20KqKW5/Q8pCtnhj0C0iDZ2dsmZnr5NV2hw/4hwYM4A+Zl8wSoFiguzkBSlQ==@kvack.org
X-Gm-Message-State: APuU4Z9lTKFSytcA88iLw7n76+k6igBpXOiZUW2gjZrkO8MRAyrYJFZH
	FdKUW1yEyqf63eoW3V04cKVMsYN6j/J7A52bqlp0+3BoGCd7UGgJ6uHgckP24q7dvYhvAjkico8
	WaqYs64XaXlGltnhFw2IcBQ==
X-Received: from wrsb1.prod.google.com ([2002:a5d:45c1:0:b0:48c:753a:6283])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:e194:0:b0:491:6a7:b4ac with SMTP id ffacd0b85a97d-499c7b1aea4mr3063798f8f.56.1794395305902;
 Wed, 11 Nov 2026 03:08:25 -0800 (PST)
Date: Wed, 11 Nov 2026 11:07:33 +0000
In-Reply-To: <20261111110738.872947-1-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111110738.872947-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111110738.872947-4-vdonnefort@google.com>
Subject: [PATCH v3 3/8] dma-contiguous: Expose rmem_cma_ops
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
	ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 376cmrmuqzyc5krracb1n6j5q7rmqr9r
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DBB1114000B
X-HE-Tag: 1794395307-896404
X-HE-Meta: U2FsdGVkX1/D1eNhjGsq6q2pCNjTRjMc/fqBYNF1T0MrfUJllwMnQLU82wL0ByfEB8ympc0DFu4PQVR4L2WEoLVN9USSdBdqbjjC3NmQTG4RYX0ReNXGpBPaxOgzhAi67H+fTW1nOJsP1LeLLGRXA1AEvdWlF1g+k/rgn3M/abQM6gEjWnTbRtLdnhdv5gJDA3k9oj6PcQXKz7ReiyAF7QqeYFRhhz7NXVBbtFDAyN/iKWAqLHN1uoYV/a5+BttvCLEsnVUzhWq8WfIlTvu3jutwm6iTHkA/fQbGT89STYP0r/myzhWUNQ3DiiW1dyUrXfGCevFRRt8xDpkmSm4Yzj2BkbscedBF1UOVT0R2v7z/xGG1VUYnqnd+PSTAubAlimASE3yjTnT2vvE4xnTCbkHAB9rktjTOqca/O/qUFpzhSjkWgJB/MTA2QwTJLFwY777a24uXOHEI7obJ7QOHuApL3o4EDfhQI5Ujc8ZCCIdTtEsuP+6JTXCDfYMgQYX5t4m3u3aRqUcikMP4jvOthDy+XRLBOKo3NKVxi8RLXCdjXRdTFQIE+O/YtxSGZbN10hhPYEY2MGkzhvKfw9ZFd1Y80shWJq3diMktU9mHp1xwIt5dVIbX1dTH7brkVEVebEz8F06YuZ/VTnqITrVK/cfBO6J4cL/ckhzpuq5ai1VrSW9nuymYONuaXTNrTt1PhA6x7SNR91GVHk65qvzHfr6qSFsPT0MSnTzgpNUSk5AM4bVJH2UZGajpvOQKPJRf+hwCrD0KzqQdHcBzaG29H76lS6MLa9EH43qJmwRJJkmbirFMmVEd+DbMuhKc8eSZpxXaYu5r6+doud+mFJJYLqJQdeh+bSAGgWcbqOEIMxz5t4IoQdywCDOoq1hln5BZLgZdrtACEYFFfy95GqwPKZp8sFQ/Ui+DG7EtYF4vSd/r1n+cAdFnzxk+4SuMfEDEgVmix3eEvFtGTzdJKex
 Z1T8wlKg
 KQ+pW0p5Cu0bV+r/ogDWJW/2Y6FhhQKvNh8VeGmINj5hgNk4SDRjbIZ82vwMLwrLjbikRjP9UmrDe6UtotVbITtltTABtYoGBsnZBZIs67Xm7hqrP1Ihw2PTjUBUymeTpmyanmlPxVCF3xdT5/zF0gijcgixTrxoRcZoA+mMB+7Ych9tVrRmTynubB0zxk/JgwcqvgjPV7BcuQHY52MZ8SwwVo1lfFo/nfVHuQmGPU9uQj2tZu+dwEFm4/W4ec9VB6nTaQePNPFrKHvF3WPjNG8OHsZjM1UlXxKnjHQ09oi+BJqUZ/IQlJ3Az6tD7t7gs7PQe+NkMl5aWuzB/hewTrdfz3IxdDTmQbUNOoN46cIMsR/koe+vaNxdkOA9tKgZTFqwGlc+an5CPZ26S1g5P83QBgtJeERLfDEHIkt9ffb/c6ZyndGdp2yRWpY86R1rk4wVGQLRlxHnuFbbjhBBIrPp2/tePYuOdfFi5IQ8n1grwX54ilNg6bx5A+FJh7m/xB1pag8SywLeermS1K5Kl1BgounQDV6NFbY537xdQstPKuB3mws2aMISnpEG4BaIe+O4jLqxjWqH5HgCsdQnh5jhvueUO6bdyez5vjtySkkM/ukj5Y8jraW/OVi2I9mjqaVMeBpZjbPfJ9Vp5Vb9bh1FbkuVGzcj+YlZLhIs5zn5aKoxMliC8GqDZdq2Dp6XghUNA8TVGiTVNi8j5RSp/uXEXTetUzJr2xfGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Expose rmem_cma_ops via a kernel/dma-private header so the upcoming
lendable-dma-pool reserved-memory handler can wrap the CMA callbacks
instead of duplicating them.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 kernel/dma/contiguous.c |  4 +++-
 kernel/dma/contiguous.h | 10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)
 create mode 100644 kernel/dma/contiguous.h

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 90937dc7c627..22d6e54aea35 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -46,6 +46,8 @@
 #include <linux/cma.h>
 #include <linux/nospec.h>
 
+#include "contiguous.h"
+
 #ifdef CONFIG_CMA_SIZE_MBYTES
 #define CMA_SIZE_MBYTES CONFIG_CMA_SIZE_MBYTES
 #else
@@ -578,7 +580,7 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 	return 0;
 }
 
-static const struct reserved_mem_ops rmem_cma_ops = {
+const struct reserved_mem_ops rmem_cma_ops = {
 	.node_validate  = rmem_cma_validate,
 	.node_fixup	= rmem_cma_fixup,
 	.node_init	= rmem_cma_setup,
diff --git a/kernel/dma/contiguous.h b/kernel/dma/contiguous.h
new file mode 100644
index 000000000000..9b1fdbfc794f
--- /dev/null
+++ b/kernel/dma/contiguous.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _KERNEL_DMA_CONTIGUOUS_H
+#define _KERNEL_DMA_CONTIGUOUS_H
+
+#ifdef CONFIG_OF_RESERVED_MEM
+struct reserved_mem_ops;
+extern const struct reserved_mem_ops rmem_cma_ops;
+#endif
+
+#endif /* _KERNEL_DMA_CONTIGUOUS_H */
-- 
2.56.0.542.g3ef89b7020-goog


