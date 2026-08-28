Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD4DEC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F566B008C; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B1A6B0095; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679AB6B0096; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB0C86B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:47:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D644160244
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:11 +0000 (UTC)
X-FDA: 85148990262.30.ECECFF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DEF4E1A0008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AlK0mVoT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787881629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F46JVlLMoxNXNINmE9LzA4Hlq6H2HwDbRZsnhixmMF8=;
	b=LceCYJCCvatCRdiRjuyldglxj9xFZYDnhcZi1XRFl0jbhMnhd9yoMsiYO6vZT9PBCBdrJQ
	E5jsYI3MfmHo4afmxPb56qCfmmHbFMr5b55Q+vUSM429s+jj/dCQLzpc+zLQJv/XvikZWG
	3L+AbcfHRuwMN0ng/S1i5ImljCYdCjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787881629;
	b=XUHtnnKx+gmJRvdPu6lQYbOVBMqlfSI593iaPhZkMOfDr2ajRWLEBAw4/ibnD1E1yZvqBC
	nZ7Jf/5CvApoNG/8nXtBP3POoCyHM6x0Pu8CY5BglmvY7kCtEmbJ0Ix0+tq0JfRD7Wvc8q
	JupmnkWXf9fOfq7g5H3hYChsALQxeGM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AlK0mVoT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC254601F7;
	Fri, 28 Aug 2026 01:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8891F00A3F;
	Fri, 28 Aug 2026 01:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787881628;
	bh=F46JVlLMoxNXNINmE9LzA4Hlq6H2HwDbRZsnhixmMF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AlK0mVoTY6sneItpiY2CtIJnhxTr/lvHMD13iW6tiNvxXPs+jwfVUykRN9ByK5wfc
	 x1jZs9BXUP1WYdd9JRQzSwrTLjtN9sF4j08XOiPmZV1qdecrzfpDztzLJEbWdeWlcI
	 9YqZE6P74LaE6M9o4dnLB5UhXfAQxd6wu5QCl62B1i8h/UP7mYAmCnzT0heXKDXzqF
	 redVhJNHObmk+V3Zo50atu/aJtEMnZ4d9C7PFHpeKWONUwl7749P7QrFbf8ERJMT0o
	 ObuDkq0todeVlkaKawJCxaeFrbgaLpprLKJ+Sqqs1V+ZwcgbwMQCtQVcK9Fwg8BAbz
	 v7ZevBSKHMFtw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 3/4] mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
Date: Thu, 27 Aug 2026 18:46:57 -0700
Message-ID: <20260828014659.121058-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828014659.121058-1-sj@kernel.org>
References: <20260828014659.121058-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DEF4E1A0008
X-Stat-Signature: 6dmnf3arq8i86omiuty7namze81utyyo
X-Rspam-User: 
X-HE-Tag: 1787881629-666543
X-HE-Meta: U2FsdGVkX1+J0ru4DMOxyrDrbkV6MsnDY10aIi3rTuNPfOcru8Vv0LvnGLsFiNPas45lGi+oZ61Zru7q5I3ZO/LAIikqmgXXMkBuPupLWITmlk1KCGrL43LYI2VUIDQHVfkThkjxm/367nc5PfHbKSysDjUWH3lwFutM6hKvdcck1OkWfHkqpJdxMhNvQEvOm+LasDaGxNqgZB1brku9d1q/XmsLhTOGDTEdnssLJpoX/1c6gJlxDPzY/K1xIcnzPBon91rdoXboKi2WqjXnn2cw19QiuOduO2/Nplnb26/mJLKMDqwvBErmLL/CpE+LGqIbelNAtwu+TBCBCDMjlXNxFkVn46T1M1ZUWJ4d61OObF3cYIpatAIPkx8ThN+xzyKEacaosz5Hq2ESQBNOvE2YxwJn7KlSVAAtGRZk1dCJ29eIr1o7SovWpes77KDHEaDsEuNligKmmCsiuhrLt/oVOrwm/73n25oEQCQzqwkxyvLAZMrRpEXEXeEpDHHCI0s037uNL00XBMAL/NCUzZTgYXv0h2VNCo6ChtbztDVfrq9D3JVSD2pF+pVpmnTKnmijxA86bwvaKSk70+RowNLmX/TYoNqtwAs1WqJauNJzYxaLFxnceNaXb6zcf+Cdrgq7YSAOixKet1362Ym3u59iZy3x47Pk55WWHlkq59p4xoyHQBu7S5CoqfilE+xJsPWqUBE6HSJnzRcn4W2LohloTvJYD6BmsWhl62RIC1Ue6CPqf82X0lSvNcusYlThvY8pmLc3zOTutZZVTbiQopUq3KtYL1v7wv283EGg4fruVGXBgY6TjrEsKw12MbQq/u4phAkM76BHf1J+QKYiheHpYDRolptAukxqyuERwDE1QgXhVnd/nBChR1XVskxq4TuxMf0gZIYsuscVNDM1kW0lzi/j8Cc31ZXpKGYUI7kB1phuu1mToIFPqDELPrSKVrL/SRc5WBLdmZrtLiD
 gjZd8zJu
 JYepS25v5p6bS+uPi42A/kX7/zybrIhjbjtx0kCs1wDXlHw7rILr1imCZ+3V8AowMzfOg8fet1iqlUZDWGCLXxdHmqm6NBURIaisUUHtOh2xpbv8UbBYqCynOY2w+sIj1uTdnxWdeam42fodn8PMyoRwwc8soMWvea+eKptcz7R5YnPzkyE5547gvqEvO6V5I3NwAm/fkGDSD1Iv74opWQOrH2ifl/t+PQxuWEpRUCeGygmDTkEO9hgFkONFaUHcO1HKTUvs1uXYIxmNNcGQZpKL2hM2nBxneUnD8EdEwFeuAgVY6OMimijDLa9sXGgQF7M/AYwilyJyQo90wyMDVTgmxJjM679Mp7rESPfZ5jY3z6rwFrCg8mvfIkm+I33nzIExMI5Tx+YxkilfZR1aO5mXiAGMF6F6Jw1mt
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
index f7e66898aeb84..ce649553d768d 100644
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

