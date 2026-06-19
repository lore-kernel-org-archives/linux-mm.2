Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C06D9CDB466
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5266B008A; Fri, 19 Jun 2026 10:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBD676B0093; Fri, 19 Jun 2026 10:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD26A6B0095; Fri, 19 Jun 2026 10:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B14CA6B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:59:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BC67120489
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:59:29 +0000 (UTC)
X-FDA: 84896970858.10.4A285CB
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4FEA91A0008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:59:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781881166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IT/yVAiDabUqiE4USPZqQnbFTAYiEWdtK+BgXtb/JJ0=;
	b=scIEok5pk1wR0vCjbcOHTbR210j6uGVOb+iBKLL0Rl1AxPfTLM3SgxkxJWxVRGt8cO/O2j
	Ac9vmRTkMZN2v79YPbIbQ72FCOrUJDqegm6m7VsCgVWyJ8jw0SX9v2K3iwa5qgic23Y/U/
	0zfxyHfKdhHluPr4e4wimdIwmdp1vmA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781881166;
	b=Qsw2qzVdwJzMd8c4z9L7JPXhYftdCO3K3+zgoE3MY9qD2f8DuVUncReE1Cpq8B3uViNdT5
	cq2WmWl7uNnKjPNIiVMWwduvsUCEvfRGYI7qfWkdqXawrg0kuGvw8Afu0UdaMuzFqtINgr
	nTDsQiyRIdHxaGbkgUepDzA4Ij6/pA8=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ghghz71KlzHnGfT;
	Fri, 19 Jun 2026 22:58:59 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 7753B40571;
	Fri, 19 Jun 2026 22:59:22 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Jun 2026 17:59:22 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] Docs/mm/damon/design: Document hugepage_mem_bp target metric
Date: Fri, 19 Jun 2026 14:58:21 +0000
Message-ID: <20260619145821.2109933-4-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260619145821.2109933-1-gutierrez.asier@huawei-partners.com>
References: <20260619145821.2109933-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4FEA91A0008
X-Stat-Signature: bxqw653x7n6wi6mqn8b3ihyp94rj1tx1
X-HE-Tag: 1781881166-235568
X-HE-Meta: U2FsdGVkX18aq0szPLli1ngIwxXIRKBN8qHHyU25a4DPorP77i5wIuGhV9RL60GnuJPAYvRq78fcogoTvrpGoqlaShXD+Y0BFgPkgssX9KTTCwwc7ycgWdX1VwFHGPji1GSz/xW5eMWPR+0eCwg62nrD724qghCYW2Ia83f7k8Kwl2GayyoMu3lm9gT8Jb1/4RMsTrFtDYKdFeFV0+/HJcYMlxmhU3QqEzP1YUz3ShM02BghxwQPK4MzjwIn2++kd/SBRMP32GxEnWMFHnWNtCrq8aGMBu3XY/3pp1ioaA23vxbJ9OZzOvlA0Zw9Omv2PyMe2Zi8cs3jbzmrVChgmLSrkFhrbxTL3cFCJsyzNGijK3rPJD6XXZkUX1LxTpQVpmAXkk1lOl6SRVtR2v7TkRMBP30LkHvz1gpJqviPKu7s/YQcuYD1d70eGFE8HM8jMkjxHTdZka2uZe6gd+g90RlQ7Fwp0ZHRQUaeTNnkutp+unyP74rWdJ3+5IomHb3BT13DJ2zTxEyON1uFmbCAgSh2gSyti6aFQTLnvN/IS+dN0n5VVAuIiVeprw4K7H/2P2NEHIe3n7wFyOjdY6E3A0Cd65YxQV9/3MRik7xcF1WXWOV2MzMRayPgCRTrc0pEsMnELwPaIRRNKDinxyr/i/NeGPhq7bSAuOzuxT91yVzekiZ+ljeFY2CKnnTXc/eHQPLdXthttkmnG5f+6Ji/kNJv2QMpNUG9rzhXoAIJ8aIvrN2lncO3SAYTYwiL6uwEqa8Ibnwz+RFziPGZU+hjxEYNNmtrxEoWZPmfz+IKKllHvp7DonhlGFHJNBr7m3mvkATdEiohTwW8WqO3ny85UFxV6wNUmhuRe60Cv0JEJrcTEd64uI5p9oCxz3fEaW4Cf3cYXbxrIF3RrQ/TaYYurn7Eq1QwYrBShIXp7aGSL5qsMQ0ZsmZBfYCxkEM7G25EgX0s5BlIw0YcB1QjdN/
 AcBoZ9UJ
 XGRW4YBbsXzrt9WIUt84z6NXUr560XqG3aRplf1gerNphFAQRZyBOEWwWKt1O1hPWp+J9GBYHOBbYgCPtYlal6e9YGzPEJyhaDkWV2DGeL/XaJNqiavXpzmvSW1pgd06EQa53FFcbDHopSo7dIZ0T41oxK9CUxmAufXWT9kYBlxobXhdxhgLRgY07/C469qDxnaMsIp7HDIsKQVigqE2/NTlgUR3mZDGkeF80YgfYmIUexQbQVP6mPjygPY7RAOUiFZiCS6qUHCAcRa0AAIyfChoNTzfnAYPpm/aIz7xKcNX/mTi0vTGXZruZO9N0tgOPFsJC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Document huge_mem_bp metric exposed by sysfs.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2da7ca0d3d17..34d940a13a85 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -686,6 +686,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   (1/10,000).
 - ``inactive_mem_bp``: Inactive to active + inactive (LRU) memory size ratio in
   bp (1/10,000).
+- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
+  (1/10,000).
 
 ``nid`` is optionally required for only ``node_mem_used_bp``,
 ``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
-- 
2.43.0


