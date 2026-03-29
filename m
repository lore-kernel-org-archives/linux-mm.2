Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB4EF3D5EA
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 04:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6C56B008A; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB05E6B0098; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6F16B0098; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F29A6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F70D1B72DB
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:39:08 +0000 (UTC)
X-FDA: 84597845976.29.7317068
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 89C3420002
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:39:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cRiQBnpb;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774759146; a=rsa-sha256;
	cv=none;
	b=pbrfmGPS4LPYiOLXPxV6U2WZNswxyOMH0a5Yx9M/krL0dOQoKXm76gVGDCcKvYXWodXBq+
	B9wx+PTR5p4REPZxaFSY6yTNanXuKoY2OkRaV2gxiUAu+gtRLmCPNTG+/eNm4fHw5pyEOI
	EJdvJMLNSRJwy96D1fYYUZzCcfxvOMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774759146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ph1Sg8hlowVBDsmlR3AM1G8gqh8qtS2Q/Y/LZE3PM6I=;
	b=M6nQAPc/ixIdUfbIJCteY0xlVKO4GkJM2mYNcfkcQZowy4S8zA9GHRUMnM0bXJOzIyA/zm
	MhaMq8a5DYJ1WpLUWGceLNVULB9J8i/bOSCvmqO684k/eCp5loatWuNs7Of0JklDLuAy1+
	M/zjwiw1sg4EPVw3OfpiH5JsEX3OZFI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cRiQBnpb;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EDDF40C30;
	Sun, 29 Mar 2026 04:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED03C2BCB2;
	Sun, 29 Mar 2026 04:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774759145;
	bh=EHLWGxW7vsnb0JYbS1TWbmzJf4dzLg0vok6TKbBxOAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRiQBnpb3XEA6rAA2mvK45qT/sGo9EjJNFM+Sm+SPUYiEqKvL35//LdstMht86/HP
	 DLPR+lCWNEoMOkaD8BQJs5tOqjukX8qhEowT/b8epdtLSnHpTVscHbGIuCfwHWy3W7
	 D9heDL3idd2cC8nXU378P2ejN4NPzWPl9pgzFKI4MTppraMimCoCQWgVqb6jWCUl9a
	 XPif1dFwd/SWoFae3gIFFnpGLade3TPKuyFVvUoxBtvr8y1J6yP/H/Go0cfLbGbjGc
	 KGlLq/4ZsGr9wBGXwAyTeUZoOWHLRTx1utPGe54LAxKznfXrv6cRfDupL+EzH5Si+y
	 8DYVHH6JP/eRQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
Date: Sat, 28 Mar 2026 21:38:59 -0700
Message-ID: <20260329043902.46163-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329043902.46163-1-sj@kernel.org>
References: <20260329043902.46163-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 89C3420002
X-Stat-Signature: cy3xatoaegmk3w9d9untscpq1d81dduf
X-HE-Tag: 1774759146-34004
X-HE-Meta: U2FsdGVkX18/btZ+Ul6zvokTwD90E5m74WpWrAVaBtA1Bj+Md9N3oZ/OMq9q9Po0rVGiluSmvQp+uE6OBH+nLL2gFzYvlkpcbI3Ns9nidrNSXJDuDhPYl7CGmLO5YGWOfRfC54GIUJx7EZjGXR9n0MKAXc9q8+J69GtbWwBr1Xw2Oybsmfke9qgcXa2bLMUM1Ens6D9PmxhfJk7fQmPZsCUhIU65CLArtrBDbi0bRW2MNuLxqVYKbs5LrEb26AGyh/WUXLMQpQVG7LCmX0oWBrpeCxzxy1n+QSxuT8vXjGQrnKPVM8YumMpCx/EDt+QLdTkIL6+oX0kxsnsZGe4DUPoG9Y4elrqkr+r6BkRboo2lz189diXxC+M33x09xWTyb1LRrV61xTEnRPuOMCBx1Is+n1cZXR/LG6erwa5bHbcnQzSsQj1OSsJfsUUOJrcoHYIyu3oVa5TFeS+SBKgP2Bxd5+o+5eCCd4kp1x7BqFww/AwCCGucn1QExBisXZSIpjNT3kQyjeV2axt2GiFDHprfczYivlRAdSHlnpg8ZJpnS6RfSzqp0HxJbB9WqmjvT+/frO9gABZKeVMYu4/Djrw1IK52R6vclkFMzVzsKaPV6VU2jeLFW1gPz2b5aHCphH1+/4E8q/3PCaxKfn7NOi4XGi1U6c3qDqbOYsAWuoEzuk2oFF4zoXEXfuAnQE8ikdF/eXmH6o6QwollCYCKslhHPRoJxpQRSbzi58NzCHKvhX996XlOHiFEhNqpnspt+sMp6EG4/1FUzMkB2lawe95mQ9key9ni5o0lhAqWvEZG/NWWwU1btb2mE91y08NJ5m6zzINj+R6A9emVcKcwoeaHMG9TjdMiRrW3L9vAVcRW+2L8xVccOUUeaeJp2VkctQY8n8+QNHMa/gVUHUbhx/DjSbt3Ke9/fZgAVrT3JJlkbs1+aWqp8+rhR8+RzwIuFKIdra9/LCIt38zxbwm
 SN1XqHet
 K5UWaj4m6dZ228T6lFOnQHRzwQznn4oV9ybbFhW9mtTXtjRaG7DAmuHlMM1+j69IeedZi787SENuczDTaXwsqJEoEC4r89YjsyIcC0obF+gM6ZMmU4HMlBOibufzCBijibYiDGs+JZkILurinToegqMrIOmqyPxHkA1dV7CKOB+1z4P9qKPlaspxfcdIPjXIyvR+rrGUXvSmlcxsP9y6ZoNTKFcRjh8vCk9WyJwMiYv76ncHINsIEqf9VAdfFRZVnLbEM7sWFHEQ4pPwJ49EzX1X39A==
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

