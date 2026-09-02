Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E06C61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908756B0095; Tue,  1 Sep 2026 20:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842846B0099; Tue,  1 Sep 2026 20:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6951D6B0096; Tue,  1 Sep 2026 20:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2096B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:27:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C8841C2382
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:36 +0000 (UTC)
X-FDA: 85166933712.03.51DCBED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 995FD20002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QacSCw1g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788308854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgVH3jXroigXUbQaVhPgGVZ8NdHiYPKQ6daDtsHhDVg=;
	b=Bx0T2FwddGxE7kZKqPv68PzAwFh/R+T4ZYTZrkbaqDDpbqNFXqGHnZ+7YPxTZhxEryHAh2
	vq5nhVGO6zCDjkrsXepY/f8FQ8qZpV1XcAU2AA1KF91C+9F1KgrmJlhaYsJs2kT1m0aT8L
	JAGEmdM9YGsvFVxxks5bxVDCmUOBdtA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788308854;
	b=kvcYKf4R6cn3rObIf/OR/AV0gXmPEmD90rs/KoHMEuXwyZCPTbyXd7xatInsiNmU2KLRq3
	wK2wgpcVxGMUOi7P6hQkbzhKVsctR+EfPM7YsM6U/Jc40tPs2yuoq4IaUEonxVuvJdL4ah
	pg2DRvMRIocHWIwO+GMTw7CoICPYoww=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QacSCw1g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFBFA416B6;
	Wed,  2 Sep 2026 00:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5061F00A3F;
	Wed,  2 Sep 2026 00:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788308853;
	bh=KgVH3jXroigXUbQaVhPgGVZ8NdHiYPKQ6daDtsHhDVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QacSCw1gsI5N0HGKudxjhUx3D/hC8VbYXVePH9gDtXWWcKeurZ+Zf11T80nVvNKOM
	 7SK0Nbuhxra1HuTtRAazt2utA3ruJC9trhXfLzMIv329BicGcqudFTXUPS397jimdd
	 xWK6HEcOMwsSRz8kabDpie08JwrvcbqVZAp7WUhpp2TjGJzCOnse8ufokprHt4QR57
	 EOeaEsL0cW496EETLYaOQePpD/0aVH+LRRIDxN3B842siNm8T8PT/VY210obNOS2hy
	 a5wt5cs4S698A5jpWb7apPXmLDPiZLM/D/0qdKvbGGOoAVb6QZWNqyUsPPt3aG1b6W
	 u6YcZcyESewvA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
Date: Tue,  1 Sep 2026 17:27:22 -0700
Message-ID: <20260902002725.108635-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902002725.108635-1-sj@kernel.org>
References: <20260902002725.108635-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 995FD20002
X-Stat-Signature: kea1mwycromfp4w1hdibkxcizg9899hz
X-Rspam-User: 
X-HE-Tag: 1788308854-433888
X-HE-Meta: U2FsdGVkX1+bjuefUmp4vWPIejGfpbcL4Nmf9F9rQ2A8eypgjvWKZvrrFkXmDX8Ce31a3xfZHdwZKPScc8/Ux6LSuBgSLT0TisqYODaBxjwmKqIfzTbdo5Z90HJhRrhNiQMgLbHEsqavn4EnBEGEDZJ2QQCwCTFft8JuUFwdFahGw0c6j7VpZnVkpc6c0/9BiUVb9Lo/GPKiTspnkcyeJpKgOY2JsQPL4lYmSU0v7ugLzt4daOSAGwQY/1lZzqWdW4W+8WnpsVTFFGatVLl8PxiBDnovnlV4AtehxfqTYt/mUeW7EwK8adTWODmUZxjoW72d3Z/VAWOHMOom21vNXC8WnhDP1wy4NcG5XRlcAGtFZVlUpzQTiD0dHukxY5azeAXoiroiKOKIj18/NETOqoBhY1Keyf02YuYblKEqDz7TpwPHZZ/3KS9qCT8b5TaSp+B4bXKTWkA+8Y6otNbkXEJZ73UVlMV5iZTFzEPBfv0S+bl2a8hwE28IQzM35+PKeXoxqZAHdmCEkGJ/819//VbmEnXoX6N7yjomNjCId1/AO967+suurtaJ3Hp6RX6i4uvGp6BYI/yv9OAPLQ0zZ27TXzVmjyRLNtncC/k2pbY6c1/svcl5rNhzXcLqKF6pVtm6OF4ZKfIb5B5P0kPjN4aVm3P6QqeDRbRHtXOatCLCJbgxAhWwWS9c5TQPUaom1WzJIk+rzDoNftoLKce1OzacUIiW45hOibcL0ntVrPFb9kg/pmbvJWMnMElZsTZdzNjxmSGwD10mky0tSyygUNkAPYsMvEz8lBABu8/LwQ5NpbESstHhugH+YUbu+oOYFnTlys2EUnt5kT/bcMziKuM8ikFxoYzuXqAw4PCj6Nl0TAYGGbi9i4vMJUXtFIRVqGP6HpDSE24U2s6ChKbnnDALWn1q4pxRVAreWgHIV32i1tSm5yKA+hmkUJnYISaCsv78sbir8l8bIF+o9I/
 3DxnHRNw
 SZk1lwmUuoCj6bTC2dSdWf9iTOogYLVlA2HPCR2o3k1MahiSZfYeT/dHpXaYjSAObP8P4AMKAH70wCPH3m81r7/8GYW7DnkmDR8xFJfRRABC3Ukt05VKWDciCXTjVfvpNObiD1+56D8sfgEZCSnU745c8d+WLYqIwLpmNQxGBHz5OdqixTRiF1cG27qMnVflIbDyUtx/tC5AvqxXFnrtih6l3jQPYMfsf5U/Au8ssrHbIDNs12hecfX6nt6vDQW3ScX0zSIh7oCw/B+MzuAac8JTrhGJMEtD9dK36XtYGnJrUqBE7/JMUvC0mAsCFBlHqx5MWRPHp9L6podf2TC0mfPkCOaBU7Kg6FbMcil26wHcSwNZoMzpnqgr0KTRinhLEblrAuIOfsojoFanSMnH2BA4PlWWXvklxdDfg
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
index 20748b0a71026..53c3f97e3f126 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1143,6 +1143,9 @@ static void damos_commit_quota_goal_union(
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

