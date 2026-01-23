Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D883D7234A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE32A6B0447; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD206B044A; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66006B0449; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BEAC6B0444
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 503B51384CC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:24:02 +0000 (UTC)
X-FDA: 84362540724.08.CF8A4E8
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf21.hostedemail.com (Postfix) with ESMTP id D67191C0007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N8UOb1xg;
	spf=pass (imf21.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4ux9tDlFdT94Vxn27fx7SeIZf5wjhCyTIcjZvfwWJQ=;
	b=o9lPivV/rl7TaGmKflvm0PMGzvXamNt4egN6ZHtz9rUJfbDvMYSXYtJjF1YgAH68zbgZl9
	KFx3CL1jZjJvjEMqVV3irm47erMRZ5sYWCfEiegwCMg0yYx+vLqWmsuzik8KMbCa2QUINt
	NMLeD0jfufR7XyonSSE4Qva2O5cE+Bk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N8UOb1xg;
	spf=pass (imf21.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156640; a=rsa-sha256;
	cv=none;
	b=CDs4vcpoB8aVXcTSeC7y0Lt12CqlfO0gWNtLjaYmDmC8x/U1DYbXuFigUNOakqK3DjmrAi
	mv1v/7/nzLagcYv9ChaYfJ/GqiF5uApxzqpATCx6jiycbZXi2be7hYDLA/Q5g5Iih0iZnD
	cVC0H/EnvPOFq2xWlGcY6JJM/0KetRs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769156635; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=l4ux9tDlFdT94Vxn27fx7SeIZf5wjhCyTIcjZvfwWJQ=;
	b=N8UOb1xgztH32QrTnJLQ0HErMKTEVypillYb5NrAbLG8ndcOQhHNa5GUXp/tWaUXBbOfNbs+VD1vFb5i1Y0P+GybToMmiESnuDDiAbyqHpWzV/RypwVcPh2RbmnhuKjZRNxA0AGfDLYQtSrrLl6WwPx+fEgjmwlXaCH9gy6mxtI=
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wxf8ov-_1769156634 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 16:23:54 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: [PATCH net-next 1/3] net/smc: cap allocation order for SMC-R physically contiguous buffers
Date: Fri, 23 Jan 2026 16:23:47 +0800
Message-ID: <20260123082349.42663-2-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260123082349.42663-1-alibuda@linux.alibaba.com>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D67191C0007
X-Stat-Signature: fcxdcetkmfyn4wezwbm841hfb47osnzj
X-Rspam-User: 
X-HE-Tag: 1769156639-70342
X-HE-Meta: U2FsdGVkX19dCrXHAGrH8ieZbGf5A8vPSL6rI2HhnDDe9C8eU6YFT2S/DaWcIB0Mz4HSzppgk4eiEzsHQ0qKp+9s7IBQN3PVATbimGGuFz6NSx9V5YiwBPN0mVbYoOD2T4MftKMzo2fYW2y73hXqNHL/A04P5GzI2AxKjxAfaTmogXVInwg0Cnv43k8ECZxGd4vJYREDAiCTx4m88+uYiv2OXN+fr1pMYAk6mrQG2rFKWaDrGjFrgMRzbg/Dis1ECFRANou0nt3KTyx98fx8BtnRkdDumroYd1d4qxynIAPi9tvJDelMSiaJGN00uIBgqoroEp8lZ7puABDzNgjIiHjy1p15ublOukg4pDzka0DLcd7qUUrEn23klCspJh/q8RgYAKM9KYZ2yebypc6Tdohhsy7I9WXlk9DKzOltwg673m/4ZOmylnAIyK/S8rOHrmrjEURKVmy8ECwA6NT+kWrDn7HNMYxuvbYVDpUdfumLBjVCpD/PI1jG5JTRQyW3XRVi9TbbzxLQj1Xs/FAuk70yPLK4LWcLrmZ30HGC6tSO7g2KfeEBCZ7RkEAuMqHWL2/3tfL8zFR49IWNkAiBgkINRR+AespvtgDtaR2A8i2464DVzcxec1zfskpdT+6rfFQZ5l/9FHkpTykpv97wQDa4QZyTVozJzXha3TlyIRRvfNS29oKR4JgjEQfnzqGBgb37ZBzJAjxM1ew5x7ChKVAQFVZNyrWDClK84vGzR7wWoWIF+zTeimuWSqzCfS/LNZ82YaR4EsZ+/gCG7qBa5CR65nz2Y6buGdQq3WybD1YAS1LksadtsxZL3Rq1ZTxACQ+Yzsuxb5iJ98B8cML6P+lbr9etpDueSqTNhRbCxX+MxQDQDX3hDUcOh/oZp1jHSzlRInQ+4eXYsREljlX81Jw3jKP5Xnoux50m/jhnBw3TcvtJskyoP0OZuzxMzxDTv0Mfk87yjiJot9qRU7q
 z0gsjRzo
 ydnRECNVh6Cbd3IdsvkGLAJNMxlRJng6AeCVvNjw+KV7FI/6M2YDCFsGNr7ha4m65wIOi9RNL4iKj0iAj5Q1FbicvIPHHLegZr/JShbuG5lpLgvrOGsuypntSm7eG5P3krY2Qz8q+ci9rf/Msdlp39c+ZXcQDQHqUAb5Jk3gxV+m1Pp/hhvVXeWfKT8EfKtqL2xMwuBBa3s6ek8/FvWM12EUHRCyFj8ZPxekFo4oggdxOn4fg1aXNyRq27PBtSFlzMB9o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_page() cannot satisfy requests exceeding MAX_PAGE_ORDER,
and attempting such allocations will lead to guaranteed failures
and potential kernel warnings.

For SMCR_PHYS_CONT_BUFS, the allocation order is now capped to
MAX_PAGE_ORDER, ensures the attempts to allocate the largest possible
physically contiguous chunk instead of failing with an invalid order,
which also avoid redundant "try-fail-degrade" cycles in __smc_buf_create().

For SMCR_MIXED_BUFS, If it's order exceeds MAX_PAGE_ORDER, skips the
doomed physical allocation attempt and fallback to virtual memory
immediately.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_core.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index e4eabc83719e..6219db498976 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2324,26 +2324,30 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 	if (!buf_desc)
 		return ERR_PTR(-ENOMEM);
 
+	buf_desc->order = get_order(bufsize);
+
 	switch (lgr->buf_type) {
 	case SMCR_PHYS_CONT_BUFS:
+		buf_desc->order = min(buf_desc->order, MAX_PAGE_ORDER);
+		fallthrough;
 	case SMCR_MIXED_BUFS:
-		buf_desc->order = get_order(bufsize);
-		buf_desc->pages = alloc_pages(GFP_KERNEL | __GFP_NOWARN |
-					      __GFP_NOMEMALLOC | __GFP_COMP |
-					      __GFP_NORETRY | __GFP_ZERO,
-					      buf_desc->order);
-		if (buf_desc->pages) {
-			buf_desc->cpu_addr =
-				(void *)page_address(buf_desc->pages);
-			buf_desc->len = bufsize;
-			buf_desc->is_vm = false;
-			break;
+		if (buf_desc->order <= MAX_PAGE_ORDER) {
+			buf_desc->pages = alloc_pages(GFP_KERNEL | __GFP_NOWARN |
+						      __GFP_NOMEMALLOC | __GFP_COMP |
+						      __GFP_NORETRY | __GFP_ZERO,
+						      buf_desc->order);
+			if (buf_desc->pages) {
+				buf_desc->cpu_addr =
+					(void *)page_address(buf_desc->pages);
+				buf_desc->len = bufsize;
+				buf_desc->is_vm = false;
+				break;
+			}
 		}
 		if (lgr->buf_type == SMCR_PHYS_CONT_BUFS)
 			goto out;
 		fallthrough;	// try virtually contiguous buf
 	case SMCR_VIRT_CONT_BUFS:
-		buf_desc->order = get_order(bufsize);
 		buf_desc->cpu_addr = vzalloc(PAGE_SIZE << buf_desc->order);
 		if (!buf_desc->cpu_addr)
 			goto out;
-- 
2.45.0


