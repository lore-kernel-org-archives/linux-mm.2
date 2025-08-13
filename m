Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5008CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265498E01A4; Tue, 12 Aug 2025 23:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218AC8E01AC; Tue, 12 Aug 2025 23:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068C88E01A4; Tue, 12 Aug 2025 23:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCC6B8E01AC
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77FA2136D18
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:40 +0000 (UTC)
X-FDA: 83770362480.22.6E8F3F6
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf17.hostedemail.com (Postfix) with ESMTP id 573C940006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGdNOAYl+Pz0Ni+J7L79h/lgSIrSwtEIAb+WC1AXJe0=;
	b=7Vll+FbtLinyIvnf8qW8w+zHAZw87TY8jgIeqOkmveHKSIvgBr2OtrzndCzNNV0r9aLtjT
	mLkYBzGdbJrNXu9AoTVIof5XFq05iE3pAGjxncfE8Qiv2fyzsllR0of/oy0lAA8mH+TM0I
	8k5V1g0opTAMEQwwDlVA5nwKQJwucR0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057158; a=rsa-sha256;
	cv=none;
	b=7HteTJlrZonbzocd9cIY1Ycv0mWOQPnabBAp00dJ+WCtnH9YVxTCh3LYJS4KgafspAK1Ba
	SV/UCv/Fc31b0y4BcvA7uJEGmvff/hspPfUiKMR+2zdZBd4O6ncX0R2YSNsbi5Td1LCmE4
	CsjwRtYaHJubAklwJURYJgOaQLmjH/Q=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c1vTN04kPz14MTY;
	Wed, 13 Aug 2025 11:47:36 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F63818048D;
	Wed, 13 Aug 2025 11:52:35 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:34 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 08/16] Docs/mm/damon/design: document 'address unit' parameter
Date: Wed, 13 Aug 2025 13:06:58 +0800
Message-ID: <20250813050706.1564229-9-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 573C940006
X-Stat-Signature: n7keaoesf9rdakogr8f56pp1c4nikaxh
X-Rspam-User: 
X-HE-Tag: 1755057157-227855
X-HE-Meta: U2FsdGVkX19XzYizp3hzI48VJpCE5sr3LIKDDDCOCVG2RTskW6hgWQW+fgmfJDzbLTs/hTq8jIBRavjEBHNws0lwBvkNMvekwRe5cwLpbQdnJWMKZUD+g1+cj/NcWFH6ZNwlgDRTojTi4yJ+BIHcCjJzOlRR/HHeHNlQxIxFLIiQtCFk64lAFkIG57JczSzZ3NCniy3hLfkfYZ4L/qAJ1A6m2LBzAGdqMtUH87mudh3q0RtvDj42zyC/xFDsI4oTPw3qmMXecdosN8RZ8iQC1CN1aYGPlv38yfeP0RZ251v6sdLaqsiWeBiBWkflgbwMA3rF+/FjS87PmMnbeMEnkWNMR4kZAETIq4jzUst0a+j6hjr2nB7w8OYnyDE7BD8PKNsAdg9pn+ttx0pvf+ntRZYflUywyLZo6UCc7+qi1/N+0TaxMnKu+QsrGXM920dJLWL8oynE3KRPROwsIliRbI+CuSNaXY3rjdw49R2r0db2nZ4M496zw5SfaANrLZFe1ZHBOJOTvSgsGa0R1+dfhMfHiFbftG4Gugqbop6GtlBkcHbAwrtxfw+3DutJhSPCsG7npmPLNRcWKgu5iAF3t5SA4C3b2nGOKmprkf6gYZw7uKoN+fv72001RtudHP9ty3fgvXFnymqNC1dGfE4t3oAGwfYYrdK32BrS7mfArElh6MW7raj2bDloK359fgTKc67VmILZWTZBk+Lgl7dphrjRLUm543PyqHXiuYp6aLrdUkrmMrEJmF/Y2k/lPaxO0EfKTckqawAwMkJ36hTM5/wp7VGOyGJWhISvsAKffl+N7bkA46HR29lFfxkgRLd3/rCm1w8mkQt2xZT7wshaHf4KpYTpeQF5UZ6mML16/ldw8NIUebT+nfZ4hpu/m0hDDlpqmGKBFoyYavVMRIvCKImOgIZEbq33azVKzt8mfVSwptVNBLyIsY/4JWoCYXSH3ldJaa9TBYqoseS4+PA
 DSdxXE98
 vT2rFV2C18ngjHkmwydxzVV0hJpB9xY8JXLES3VUIOnhf4sWcJDc4V4cXyehDjJDRlNORk/Im+duZRD+lvAXKrgBCr66+ILaUUkF5Xz49MGq2L/sLCzCxuqJ66xBqlAWw9cnfX/eE7QzXrVfbyoSfBWmBKZglH0d/vFZ4ITBS9PuLFZSIMf1M/jYAIbM4CVRj/I9l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Add 'addr_unit' parameter description on DAMON design document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 03f8137256f5..cffa320ead88 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -67,7 +67,7 @@ processes, NUMA nodes, files, and backing memory devices would be supportable.
 Also, if some architectures or devices support special optimized access check
 features, those will be easily configurable.
 
-DAMON currently provides below three operation sets.  Below two subsections
+DAMON currently provides below three operation sets.  Below three subsections
 describe how those work.
 
  - vaddr: Monitor virtual address spaces of specific processes
@@ -135,6 +135,18 @@ the interference is the responsibility of sysadmins.  However, it solves the
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+Address Unit
+------------
+
+DAMON core layer uses ``unsinged long`` type for monitoring target address
+ranges.  In some cases, the address space for a given operations set could be
+too large to be handled with the type.  ARM (32-bit) with large physical
+address extension is an example.  For such cases, a per-operations set
+parameter called ``address unit`` is provided.  It represents the scale factor
+that need to be multiplied to the core layer's address for calculating real
+address on the given address space.  Support of ``address unit`` parameter is
+up to each operations set implementation.  ``paddr`` is the only operations set
+implementation that supports the parameter.
 
 .. _damon_core_logic:
 
-- 
2.34.1


