Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 214B7CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA256B008A; Fri,  5 Jun 2026 04:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791746B008C; Fri,  5 Jun 2026 04:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE516B0092; Fri,  5 Jun 2026 04:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD3F6B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:12:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05FCC1C0697
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:12:41 +0000 (UTC)
X-FDA: 84845142522.27.61AB966
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf30.hostedemail.com (Postfix) with ESMTP id 281D780004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:12:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4MDYTyJr;
	spf=pass (imf30.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780647159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P/UmAPiytFwTrNcuTVo3jJjbv2ahSKmBzmXyOw4Hkt4=;
	b=QfkbJzGv6cxSVnSenolNs30wu9OeL+mP8BgtSmX3Rv5mnk1B7b+QZoI3VlnLAbQ72wKPlg
	/AMKEpDd9b+d80xm1BQ1HVGWEImnQ6sJYQlNNq56zRNWt/n50LjLSa7fgN1uJfICucuwRN
	j3Zh7+OCy5JS1ZwaOdciAuv+HgwBuc4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4MDYTyJr;
	spf=pass (imf30.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780647159;
	b=FwvCkbtpDQxPv4pNUhzZD/eXAccaBlwV9352Wv5aMEB9w0RTB8wAtnm2OIm+1PDEyGIp0j
	splusVRembU8gchhaxKkmc3XJkuFwGNzLwRBXfbEJ/HMPwbTGyU05VWVb1t8JawbmN1EiF
	Ykz8CJdyE4GFWnxBXDstGkKKSMTaoZk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=P/UmAPiytFwTrNcuTVo3jJjbv2ahSKmBzmXyOw4Hkt4=;
	b=4MDYTyJrcl90mH7iy0GfzGrN2z57Rl8+Ya9qZdl/QD3SKlaFbUfMPTFLlVGBQM31LsUVVObXW
	Mu99kjn6PeXQduuN6CAbjGtDbGIIRw7ypEyw+ITckDDkCjW98n00F15qwuZAi+Q5PORMJBqfcYW
	KbV13tO84tWm4jNvE2OeTNM=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gWv9N1jV0zmV8b;
	Fri,  5 Jun 2026 16:04:40 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A2734055B;
	Fri,  5 Jun 2026 16:12:32 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 5 Jun 2026 16:12:31 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@kernel.org>, <qiuxu.zhuo@intel.com>, <bp@alien8.de>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <mhiramat@kernel.org>,
	<mchehab+huawei@kernel.org>, <tony.luck@intel.com>, <yi1.lai@intel.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <lilinjie8@huawei.com>,
	<liaohua4@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: [PATCH] mm/memory-failure: trace: change memory_failure_event to ras subsystem
Date: Fri, 5 Jun 2026 16:12:13 +0800
Message-ID: <20260605081213.154660-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 281D780004
X-Stat-Signature: f3n7x8nobiukrprdb31yezed8q1gg1mg
X-Rspam-User: 
X-HE-Tag: 1780647158-680827
X-HE-Meta: U2FsdGVkX19zsUudtdq320maYizJWKQx+RGYhMGvu64fnclfeRy4CcqBBX6n77+zXjPEq6bSaZkdJkPZAAYC6YZ5WlJLbFrr+ihtZ5esdERTBWgQXvudq7AryWRkC3qUCCqglgFJQKqM2HXV/MBuSP9rMOMS0zz3zJxc/+IBPuaxWLap/2I32IoR9KZ/7pODd7jWULHXTFlM7CrveJH6WgEkZt44KpuNhfusdlrD0f+2SLvTTuFfrNOmL7WZltD4iz+cPP7C8JAySaZDmFa+jgIfUQoKG/+Kb4od+4UZeQJlbipo6lMJSFFk28UkDJNvwX/tjRWTtLIT5gsrx6//zoh/dKpeJNm3j1nDSCLpr/PVCVlTXhQU3+BWLyn+LwZQkJ0LGJaAyV2XoXW6PtQWicngVtKbN86VH9SO0K0jg0rZAdymNBwnwa2ofztSpllzM1SiLPrvoeGl/yTvFSCHQrbaW0N+PxA0D64XDtQ3I4jYYdhXlS8Ow6UTvVTCwVDZvK4RF8VkXi2AyBCGj5Euxn0oS4L5UJWf5+a3l14nEW5D2N8ZlCkfC8m5uGHd47LNT+BbE7vx0w3YVqC78BFM7K468iWEPo2wP0uJIlm00y0JRJlAI+7/0CYc81IivufoUDsyQtm89pCggIu9m9UHbUtR73bgSLlh9gbkwVjukJE1M+6UPAxlmTmFvRCt6hl53FuAYr/MsaJ5XbSHkBfuwTzVYm6p3So+vK7AU/OGFp3e4QpRpMDmC7xEwUA9vRTuKqR7LOYFmnQLBbt0betVWcTUCww/E6uO8wqmwgkVer5pY0idoQr4uFvKFvBLGeOUz3/y7IW0D0aJidSzQfxenhxG2vgpU0sexbREGhZmmYuPRApCGYIm9uRtV2O1r7lOtoeTH0X7rtirjnNuB0ExtiOoHOHd2KrzeC1xe/qi6EzmW/QwJkLOnPpbriS8tvXXDc4Hz77S3mhKGt4DRX3
 YsfpJPMz
 M8Jk12K1WSUdoO5xIRD4nnA41lXiPRgjzoY3Renb0qNaqQAE8J81cyyn1PQW6u+V81+4UgcnPS8+HlWOug0Ui9IDMjqxtn7dKK7LjaVrM6ES8CXJAYW3VTU2KGLK96inDivrZUvlTmq1wuyC7x3YHkM0zzhHCOJ9/+s2XpdEHdjBnKXfcECxg+jI8G83B7UPgtc6aLdJJUtlaSw6XAK9JWpIE0Jg252VeMBep47sp3tx1VSoMCNPrJ8ANJtyy+P4CLX9uhTyLFOZRYhiAbUSODkSXo/a5wQChO17nsDk5KcdQZsoIzvZzNgLRa4DHoIz9AK+kRGMDuJZeIm2jb8YuReMOoo9MhIHlGToRZWshugqBX3hSirufrNrE3eFIXCUlNs74fIL6rIth/UzypMT5RcAOm5cPRVObCo+gt6MEwxd+7CQJ+mkPGHFmRJ+96RZk43lO95vHED8c0b0gGja+lYZHVZcnfoaUYlcbAGQEmqePntN74Iy7ZyqsLsZQV/iWcu/lygL2dBnoo3E2GfMe/o/MiWhLb3SaOdHRy5d06fWzyzLAod0u3cPoiVT3480/5uuu/YGFVap9S/fYRklKZFQtmMEbvnykuDOGLgM97Zd/rcIi3nAJrtSmOM6MAjt8SssGqmsvhVwuEjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For historical version, commit 97f0b1345219 ("tracing: add trace event
for memory-failure") introduced memory_failure_event in ras subsystem.
commit 31807483d395 ("mm/memory-failure: remove the selection of RAS")
changed memory_failure_event to memory_failure subsystem. This breaks
the backward compatibility, some user programs rely on it.

Change memory_failure_event to ras subsystem to keep backward
compatibility.

Fixes: 31807483d395 ("mm/memory-failure: remove the selection of RAS")

Reported-by: Yi Lai <yi1.lai@intel.com>
Reported-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Closes: https://lore.kernel.org/linux-mm/CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
---
 include/trace/events/memory-failure.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/memory-failure.h b/include/trace/events/memory-failure.h
index aa57cc8f896b..7a8ee5d1a44e 100644
--- a/include/trace/events/memory-failure.h
+++ b/include/trace/events/memory-failure.h
@@ -1,6 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM memory_failure
+/*
+ * For historical versions, memory_failure_event is in ras subsystem,
+ * some user programs depend on it.
+ */
+#define TRACE_SYSTEM ras
 #define TRACE_INCLUDE_FILE memory-failure
 
 #if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)
-- 
2.53.0


