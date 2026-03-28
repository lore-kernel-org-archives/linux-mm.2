Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C2C10F3DC0
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9FE76B0098; Fri, 27 Mar 2026 20:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F7D6B009B; Fri, 27 Mar 2026 20:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F866B0099; Fri, 27 Mar 2026 20:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE8046B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:54:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BED414066E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:54:18 +0000 (UTC)
X-FDA: 84593650596.05.B48476C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A5471C0007
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:54:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dkaZ9zBo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774659256; a=rsa-sha256;
	cv=none;
	b=PGePdCV2O/beyWTBLaCvUesI1wUr75F8I57azeuvS8rHAPwsxeo4195hfNrHH//E7ov77X
	8stwvc4037MWz6aLwaMtCQKQBEYWX1WnoC52QA3tW0BKrHK5ETuiAxG0wBbIQQI0SwdUT7
	P8zT/lI37awMyY5m89lcSBpCPJBpkdI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dkaZ9zBo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774659256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ph1Sg8hlowVBDsmlR3AM1G8gqh8qtS2Q/Y/LZE3PM6I=;
	b=t728W/9rsTTQFATiE2i3EiYBJIKuUohEzj2mu2eRAcbNzLXSt4ZEJQjF1DYmJG8+DtXITY
	BA1lAAAnGjc4DqksWNtSybx/tYd7qTysk+ql7EAkeHC7STFpI7fi5O90BI5ganyWiNpLqK
	+fp5v0SnvkFBW6ZuHXV5mTPQrWZg8iI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E137740385;
	Sat, 28 Mar 2026 00:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D3FC2BCB0;
	Sat, 28 Mar 2026 00:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774659255;
	bh=EHLWGxW7vsnb0JYbS1TWbmzJf4dzLg0vok6TKbBxOAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkaZ9zBomPRQ+/8phFDN9AKHVfEBRRt38uDsGp6mpXJLvug7ixW8IHmvJV5eH7E3g
	 2oZ8SFqR90FU/B/+wzOwZEpVc1XeAgZhl4aIck42TExPvnhIg0PNSqso7vcTOy9GTt
	 tckowld3wpqfT2RDJ+cauwTSLTnH88lQLgs795gXOMPKK0O4HVcFC2Bn5N1vbJiAjZ
	 hfY8Qk/tqC8t0p0WWTHx2D0qFFdgAvaheMxRrML0p2nYc+r10ATRWBP6eXD2Kd25A6
	 SblwxnXqNOAfw8AUAQ74l8lXXctaZdUUtAaDDHzgR7VFQxxizVakS0CRU+fb61qXey
	 QSaTIQ4Kaueug==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/2] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
Date: Fri, 27 Mar 2026 17:54:09 -0700
Message-ID: <20260328005412.7606-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328005412.7606-1-sj@kernel.org>
References: <20260328005412.7606-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yikpnqqxpknz57r8suqkw3qqg546sgoo
X-Rspamd-Queue-Id: A5471C0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774659256-968091
X-HE-Meta: U2FsdGVkX18ALmxrzx5i8emK83M+aCP4CXuwdMpMVxMSsuUrUfqcS98IhxcypA4JkgMLYngRpjZ6TYsh/83qTXtL42IRAAXOVw+7txUL4T/NB9+Vo2+KjyzT6yJNbPaFRsNCh80nTdJfEM4UG8UYCbjv+AszVgFfpsjPDkPwawLUse/hxhd8xmHa4sQzKsLROsRgbeiON+Q19C2ETxGt7jFzB7ehWn2JKpYIUtlLTm1JE8LipIC/mq/hDQbYflg5fDv9DUWlYEGwSrBPvPdIbQ8f+yNBaDJ2opmpsXjTz0/KTucuftWo1yySMkL0hek/BXiLLJIo4/9nX0Z1BcQxvexcN67aUeXpYw3GZoA8rLtXBV2GA7ybgxwJOj5eOl9getgf7pu2o+RZbgfOMJvD/tokyRCM1CunydPtAv/Cj+nuwmBZFzBL4Ircq1vGAszuQtUV4e+LRWwVMI4WN9ya5CoUUrJFn2d26zjlQMfiGb+/XJQbcQ9WeKrVWD8Wl30fQXeVyzPnbQgUFrJwPyKYhdRQ2lSnHXWcJ2ypMdYVB0s0rsSfCg9Ci4oGlmx1unevt+wBJwPIBSCaThSPY3OxpFdg7hhbRuMBQSe91qChxmEs5N6S/wynckK3RqkcPqCbB7AOhn7tUylDCOCpma8EsIucGpKYsV1WonyuQ/DEYtJKqaOf0Fbr1biAMyz8Bmb3ABSPuTwWepXsvjJoPc7+Eexa6dGbzZwaF7NfGn6yKTWiD9jbO6NuzU8/55lC9P2hd/QX5CxFj6Cqo6mr49Bv9A6V2U0n3gQwnnyBnWO5eWAFF7frVEEn4Cq244zSWcCgPXn+R+4Cxp36zUHyLAP6jTOlhCcFMzM2uC7jT4PizLMttdTEIehbVqA6uaZKa7ayeSocl+zXgCIoC1j93J8Y2LCXhEy1nuoYYOWvcL9TjTHfpWTk4Uy9n8CZ8pJrJSFJYjSTjSh6dlrD9CuicsW
 IHIiMn8i
 L2sjeT4JLI1fuqqef6eAPSTJQy2y5PehLLfobRxPodXChrVEYlwJ/QcLDpkL7Lz1uJPUJS9fFLfmMnqBTarvW4j0B8LXYBwXeupPlqZ5igOQRleFtwjkTrXkCQsLG5GUlJAJs6ZVg9sIKbNW4PsmCMAyJ11UIc7E1gkQK8jdJI3nlRFSlrrF2lKMsKHiP25ju1rhzaBTleRun64XtNwUoHQJwsNwuZcso1s7DNOAJH8ORc3Kciw5Sn/R+w22cYrujm8NKN4Sc5ZRZpOAZHf9d3vTMoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Users can set damos_quota_goal->nid with arbitrary value for
node_mem_{used,free}_bp.  But DAMON core is using those for
si_meminfo_node() without the validation of the value.  This can result
in out of bounds memory access.  The issue can actually triggered using
DAMON user-space tool (damo), like below.

    $ sudo ./damo start --damos_action stat \
    	--damos_quota_goal node_mem_used_bp 50% -1 \
    	--damos_quota_interval 1s
    $ sudo dmesg
    [...]
    [   65.565986] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098

Fix this issue by adding the validation of the given node.  If an
invalid node id is given, it returns 0% for used memory ratio, and 100%
for free memory ratio.

Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ddabb93f2377..9a848d7647ef 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2217,12 +2217,24 @@ static inline u64 damos_get_some_mem_psi_total(void)
 #endif	/* CONFIG_PSI */
 
 #ifdef CONFIG_NUMA
+static bool invalid_mem_node(int nid)
+{
+	return nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY);
+}
+
 static __kernel_ulong_t damos_get_node_mem_bp(
 		struct damos_quota_goal *goal)
 {
 	struct sysinfo i;
 	__kernel_ulong_t numerator;
 
+	if (invalid_mem_node(goal->nid)) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+			return 0;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 10000;
+	}
+
 	si_meminfo_node(&i, goal->nid);
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
-- 
2.47.3

