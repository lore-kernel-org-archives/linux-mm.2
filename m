Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F1F8D72347
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F116D6B0446; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FF96B044A; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1436B0446; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9832C6B0447
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:24:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49E75B6F6B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:24:02 +0000 (UTC)
X-FDA: 84362540724.10.A20C70F
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf22.hostedemail.com (Postfix) with ESMTP id DFAA6C0006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CWNdFIBu;
	spf=pass (imf22.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1bjNuHUrGPdJip9CidbGVSG4Xe7mlDtcxJDAR5+R0s=;
	b=UVYaQGIvtj6Oaa/cfIocJ3Rp5jd9GLzpDCx2OGN+zVSiKcNcY8M++bB17jwcyzTrGMXiVk
	cGFE+EIPubm5FJxBghNU7xIq67F9fLAke5UVOZjTeKygLFVtgxZBE7GdlgSY1kJQ53GnWH
	R0A2m4P0LsyodDE2G6Gvh6ARyaH70hc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CWNdFIBu;
	spf=pass (imf22.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156640; a=rsa-sha256;
	cv=none;
	b=DsFScYLv+KzEKhEe/xebB60wBrKj4nzbxsa6ZrvS22L7x831yw23s4nb7Ui1Wd/xSy8hoU
	3H5pOiT3oxm9Jp+0SrN+IOgr4jrh7PPOtam6eXMoBd/3jDeJJN+nORmIzFK9gPK0FsXgm9
	EyOrImq3gnAZDQvPHYwdtOZ5CvgNrDw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769156637; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=S1bjNuHUrGPdJip9CidbGVSG4Xe7mlDtcxJDAR5+R0s=;
	b=CWNdFIBuhN6eakJGcVvK8ZK+KZygZW+GsSqEtKtl7h+O1zNdpqU2KsbUYGCEKefNrtVEOuTJTl/jITwEL62IPvx39uEtLf/TAigoIqSbSoxXuQ8LzVZ7r6ze9P6WFgIakEIV/hxlp0eRtmQe2ePjMGvZzd7otGFiCMft7RhFyIg=
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wxf8owG_1769156635 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 16:23:55 +0800
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
Subject: [PATCH net-next 3/3] net/smc: optimize MTTE consumption for SMC-R buffers
Date: Fri, 23 Jan 2026 16:23:49 +0800
Message-ID: <20260123082349.42663-4-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260123082349.42663-1-alibuda@linux.alibaba.com>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFAA6C0006
X-Stat-Signature: r93hftuinedy15mxq3cayzids8bjxiuh
X-Rspam-User: 
X-HE-Tag: 1769156639-128220
X-HE-Meta: U2FsdGVkX19fnU/D+c6o7ZTuQb1yD/f3kx3E+YM8wpkch+3batV/vKhI9r6arLzlWV6stwlxuhDKd/K0r3pKSV8sfsnAVcjh0HH71ZSEZlifo7rwWEoPkE5S1iHVqT/IJ2NQLpT9gRWvsorPRc4h9ApJQua5nx0Ba9nE97FaV5GNjtyDFohxcNIBWaZRe2Ayb+pbvrobnrEefAlL0/KDZVaFiqO5/evpfBR0zQQj+U5+tUG27NKwcdvvYP+wVwvbwhsMGXUPbv/9RplMAGlk6+2ljacb84v6+9+zdjaqQjUmoNKsdQDXLxfOE3SwLcj2z0WimuMBzFPdEFsF7sS0G9WDySS2Khg6sMsu/gm+Mx8w+xbrjOLoLv0OSRvuqm1ivg0zXX4MObLY/DEF1tsnYQpMZJa4+ct1ZyPjuiVy1QmuX55q4ne2J7m4mlSmKD5uwtdaw+XS9ERQuLpZBto9gzJWOVkUZSJxZnDpS6autd4zApMj9VEHKrzX/K9ulXnSaKmVpfiau1PBeOV0CUCCzyPsbMSf6QtQPypRkCNpTdq2tqPu8wpWkBtap67+AraA8rdKU6BfSzhJci6Z/gMBazPoBW2LVaCaIL0qdrVbcuNHLduRFGIszIIe84KsG9cYOAi3SFwQmjkoAG3XdL33YMEGpq6YNQMStDuiyAZvD3k42pXMHmG5PdCsW1LdWu+1yDJGEuTs/Npb+DXTOeExfMnM8+zQ29kqCKqoc1hGrKeRm3ugjwcnHKInJdCuJrQxJ+S+KZBlKsYiQwQxNlxoRZreDFpFnk33Pw8mgidAC1FsWA+DU4GRCvTKol2NilgTJzSkLsAYnmidta7gsQGD/oLzk2qbpTeNrwH1ANspd2MHruZw50sfRQU3Y4oCyN11Eo+X+TS/WNHfI1UgNXjS+qOTEjFMbpGGIXkoArJe1wKsLDAc6I2euz915jsoVbrX+Tcex9qYSaJSFM2JBaV
 6J1iKYfZ
 WaaTwq8d5omGtSwXKPSRXnP4JIXuFbcVqtkeLNdOMlYMn3h/q6PULJleJcxiwkdCM4DkLCif63FX7cC9PPrDZzuWEIHMYFqcEhtwI47yzEmTdtn2BvzcXiJtDqee53x9y1FBMdco4sZd0ID9ypZPRuRCPNxT8nBWeJx5+bch3U2OElK+n6Tsgd9PX68DZSmBaNoLOoEG7rGRnwZt0/DWtp6pPDoEpk0IR/RTquQaEkSo5+2jHl/v7bnqLfSrQSDrHUSmWCA3XJb0Xk4FELx4lrouVOvgbti+QRUcej/UOgAzYYFzsgaQKTB63kUCB6DK72oUVQMCC6GZhOZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SMC-R buffers currently use 4KB page mapping for IB registration.
Each page consumes one MTTE, which is inefficient and quickly depletes
limited IB hardware resources for large buffers.

For virtual contiguous buffer, switch to vmalloc_huge() to leverage
huge page support. By using larger page sizes during IB MR registration,
we can drastically reduce MTTE consumption.

For physically contiguous buffer, the entire buffer now requires only
one single MTTE.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_core.c |  3 ++-
 net/smc/smc_ib.c   | 23 ++++++++++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 6219db498976..8aca5dc54be7 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2348,7 +2348,8 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 			goto out;
 		fallthrough;	// try virtually contiguous buf
 	case SMCR_VIRT_CONT_BUFS:
-		buf_desc->cpu_addr = vzalloc(PAGE_SIZE << buf_desc->order);
+		buf_desc->cpu_addr = vmalloc_huge(PAGE_SIZE << buf_desc->order,
+						  GFP_KERNEL | __GFP_ZERO);
 		if (!buf_desc->cpu_addr)
 			goto out;
 		buf_desc->pages = NULL;
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 1154907c5c05..67211d44a1db 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -20,6 +20,7 @@
 #include <linux/wait.h>
 #include <linux/mutex.h>
 #include <linux/inetdevice.h>
+#include <linux/vmalloc.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
 
@@ -697,6 +698,18 @@ void smc_ib_put_memory_region(struct ib_mr *mr)
 	ib_dereg_mr(mr);
 }
 
+static inline int smc_buf_get_vm_page_order(struct smc_buf_desc *buf_slot)
+{
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
+	struct vm_struct *vm;
+
+	vm = find_vm_area(buf_slot->cpu_addr);
+	return vm ? vm->page_order : 0;
+#else
+	return 0;
+#endif
+}
+
 static int smc_ib_map_mr_sg(struct smc_buf_desc *buf_slot, u8 link_idx)
 {
 	unsigned int offset = 0;
@@ -706,8 +719,9 @@ static int smc_ib_map_mr_sg(struct smc_buf_desc *buf_slot, u8 link_idx)
 	sg_num = ib_map_mr_sg(buf_slot->mr[link_idx],
 			      buf_slot->sgt[link_idx].sgl,
 			      buf_slot->sgt[link_idx].orig_nents,
-			      &offset, PAGE_SIZE);
-
+			      &offset,
+			      buf_slot->is_vm ? PAGE_SIZE << smc_buf_get_vm_page_order(buf_slot) :
+			      PAGE_SIZE << buf_slot->order);
 	return sg_num;
 }
 
@@ -719,7 +733,10 @@ int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
 		return 0; /* already done */
 
 	buf_slot->mr[link_idx] =
-		ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, 1 << buf_slot->order);
+		ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
+			    buf_slot->is_vm ?
+			    1 << (buf_slot->order - smc_buf_get_vm_page_order(buf_slot)) : 1);
+
 	if (IS_ERR(buf_slot->mr[link_idx])) {
 		int rc;
 
-- 
2.45.0


