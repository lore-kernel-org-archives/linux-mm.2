Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78031C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0B66B0099; Fri, 28 Aug 2026 14:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972996B009D; Fri, 28 Aug 2026 14:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA396B009E; Fri, 28 Aug 2026 14:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 625686B0099
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D501BC0311
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:01 +0000 (UTC)
X-FDA: 85151535042.07.53FE761
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4108A40002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZ9DFD1H;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942220;
	b=6dONdh+H5Dav1X8ol71aDBMtFUaqlTZg56ITtt3lp9haedh6gt0esMJvvrqTxQrDLs7SQM
	hP0EBL1xZMm3KRJz7goOxYZABmf34RmVJrhDBIx1slFPxlzcUcYd1R9lvvPEixzk1SNRv8
	TvvqrD8M2KCFDmdFJpuDXlSEPnhgtz8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZ9DFD1H;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+IOYzbq22lhYIf1iXAGWkCEwZrUSQpgR/aOknVb4vnM=;
	b=x6UdNLiQznUzXK/jtMpiSAN/M8n2yVAHkiEACfUj3hPM7xHgZKToo2kWo6EqhhcCnMViPl
	asPO5lfdRMaPQeSQY60/v9cNNaioCbUZX9O0xhqVBIqujO6ivwW/rUmkxvKvEjGlLIXTmC
	AuAItEz0clEzCDvWlDCcBvdn1XwW8/I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8949A416E2;
	Fri, 28 Aug 2026 18:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339101F00ADB;
	Fri, 28 Aug 2026 18:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787942219;
	bh=+IOYzbq22lhYIf1iXAGWkCEwZrUSQpgR/aOknVb4vnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZ9DFD1HCeOqE9xfWczRsB/Jf8bnqdi6VhHAyJPn52H77HPYsj9JTrPKSty0M2Kk9
	 0UL6R9253A8E9Br970ftJaIx8QNUQOOuwmGdFK4G2/v83ZRt4sfZMJEvZUl8+bXR6M
	 qZ3w4yBwNfMPmRQilj2boskC6V+LcHz+iswV3QK8p+EdHpjoPotT+3I3d+6ghAMHeX
	 A2mHtaVE8+YMuoss7QXfcfx9f4v5fSxNkqf1GlzfBoF46/uRnutowkv4Kx8kHxoBqJ
	 pvr6YxvJYZFIoRGhklUa+6cVySPOxdDQ15BW9/9+joPEm4GH0nnhmMc3VGOlR0nQxp
	 spC+8u8Q+Z7Ww==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 3/4] mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
Date: Fri, 28 Aug 2026 11:36:47 -0700
Message-ID: <20260828183649.71192-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828183649.71192-1-sj@kernel.org>
References: <20260828183649.71192-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p7ujjq5pq9q8pbxoxhofqapr1wea1bt7
X-Rspamd-Queue-Id: 4108A40002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787942220-948805
X-HE-Meta: U2FsdGVkX1+Kjyp8mT9ERPwh6b0Wx7N983oUavCytHm0fqMINMQUtxA6iJKllf8U6joRUm1Mcak+tQzt5pz0yBTfqdpN2kvLkR4mg8oTZDZpQbPqlWxb7vs1IzR8khjnKzZnabnnUnfZ+51He+xmaUcL4MfVJtluMYGNvCkZEnefsfgamsglMOz9B6Zrkj+BNYLzflMIdss/pzcCp0qkkGcROhRYX2IpMe2ADtludDJdCumnG2j3UQQPANL4tdHfuaOveIAEK+d8368vTjcVEIwZ3hXrc+PWYwKayLZXgCXO2lRwnt+VXng2XvDkaHjeGGZqDx1CThfbm88Twdh90qdk5h/Xvcf9GyIsT241QC782ywrVCJ2eYq1KkZMA/ofv+zHJUdO9a1rXzoHEQax0KjUK5ou0f8qYPNaz6+H9irB8dEgCLY6L9T1gxkGDbMw0/7kyIGT0BPT7KOrW/tS6YxYMMfp8gTKQC1yhwhbhy8P/gw0yD2uh28EkrIFa/1+Jz53F7iQkEiESigE40O7hdHO6NEdEiJtm0yzO1DU2bTavuKqM17TNjoSw1iPyFRQ20B15PxFvrjQ3eaFEmo+kXiLsPpgvtYCH9WH8oSJDaoNV+QmR2Wg723jAL5FphWqBwgBDLNCIkXHDpN2jPtLBOuq4TctGWjiiO0BxDmXluNsEX2adv2UqpW+V4XmjPyiZlHHxCWrrmQqhO6w7o1hxF4kkwvQeor/g+1xyW+Cv8oAjRv9iQZELX50zBFjkRIvxQXWxMo2wSAqNzT6WbMCvY37gQRS08GW8wRik6nE8tB7pmDfGvmQWze4SPwGM2b6mORkOZ2GoGdJl4Up+S1VNR38Bcd2zrZ+pYcuOeK3/Fc2dOfxrMoKomqu4dxyFjxaFiWw3aY6o09WegOb/SaI0YmfaD+E12YsbrlacsRBLNqMBH7Kja+TXnzg8PtOAvAuP/figlmF+yq/v2gzBdL
 IIXNx/ml
 sUbX/wxqpTu1mIlSNEhL+1dqlZ1fOKxnWhewWzI+g/BQOy9OiWw/Oc5RU8YBlVCiYDi2w+R1CH6fSr2nVcgh/PZ3oaHPZ0PBiZ4Z+0z9cckCXdQFoFRc5k/Y+vGdas0qCeLcpHkreBvKi0P6xlEzzt1K/BZFTOfE7PX2VrWYQCAtgT4OJzrTuCOeIWWFvXo1o4Oz6S8DaxlXC/8TMo0u9oi8t6BqIimXvUGZejfLDM8whu9no6+n/v10VitAjD9jhi1U2gMKklq4IDBzApzMYKfEY3taAb0dtoI86844rffS3txX7mX7q7hS3i3vFjpgVabblcw4DN3bU6SByv/m4teanNxyqnamHrBKpxCdii/3+CnZOFct5P7OXvomSuGOg2RUlZ6a3FERiqGAk+fKt7INLkvfhp99WbyJ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_quota_goal_union() is not updating the ->nid union field
when the goal metric is DAMOS_QUITA_NODE_ELIGIBLE_MEM_BP.  Hence, if a
DAMOS quota goal of the type is online committed in a way that it will
reuse other quota goal's memory space, the new goal will work with a
garbage nid value.  As a result, the DAMOS scheme can show unexpected
aggressiveness.  Do the update.

The user impact is not catastrophic.  No leak or crash happens.  Doing
the quota goal online commit that can reproduce the issue is expected to
be not common.  This issue was not found by real users but the AI
review.  That said, the issue can reliably be reproduced.

This issue was discovered [1] by Sashiko.

[1] https://lore.kkernel.org/20260827045035.94611-1-sj@kernel.org

Fixes: 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 39605e64dabf2..b3f8bea774c2d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1136,6 +1136,9 @@ static void damos_commit_quota_goal_union(
 		dst->nid = src->nid;
 		dst->memcg_id = src->memcg_id;
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		dst->nid = src->nid;
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

