Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02258606A320
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ScONmYL8
Received: by kanga.kvack.org (Postfix)
	id 08A946B05D9; Tue, 20 Oct 2026 22:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063446B05DA; Tue, 20 Oct 2026 22:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB026B05DB; Tue, 20 Oct 2026 22:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C61AA6B05D9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:44:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B048C0414
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:44:43 +0000 (UTC)
X-FDA: 85345090446.03.89EACB6
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id DC44D20005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:44:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ScONmYL8;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550681;
	b=7zHjtEzJfgbS2nxz3Zb3rFIYBjq2cVnvu7BosCZWqq5UWsO7gjvDfS8ef8Eo8jdmhGoFvI
	ub4uOd96eCcljtMCmdPynAFTTSCS2Y4sFNwPClQW90fuW9dLl7lFmS8NAjCCWERox69XNd
	/Z8bKkhCgGFZwLTq56RA5WmseuhngYc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ScONmYL8;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NLzlKEOsCi9w1u4q3xRYee71IKEIz7iOlD+JfCxLSYE=;
	b=D5Ii6+bg+05frx0jcyzzOIZWun+DmDjs//+YavbrwdM2euoxF62w73gxITdJTddM3jwhEd
	Lu7ana/hiJD0MJQqJwHy/jGrlnU/iWDiXV6PMzaA7ucTtyrIu95i5U1nFoTWDXlBd6Ii+q
	NrNhNYhZbIS5ST0DRGBc1l8Oj7GGO1w=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91ba702cceaso3461326d6.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550681; x=1793155481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NLzlKEOsCi9w1u4q3xRYee71IKEIz7iOlD+JfCxLSYE=;
        b=ScONmYL8O631+f6sOt5aiAkb/mRkZBM9uQMpj8jWyKgx0Ga8v984rux7LLjhvjhHgP
         N94vDkl5cB0WontLafEa8rUMo+qX3bq9v9da/HmX8k4i1BIXHScLeLMCOuNUhD5TJyNH
         wB0BnI5FImuX5XTa09y85lqSIbe5WcBqY/H8tnSlNzrmBmbHUppGfzleIejNF293rqYO
         YqboSDA4MHO+FTz+dkNFcK5RqOucgCGQMbL1f8xbC0y8+mG9x0MQ+sfE1Tm4OaHZudUP
         DpTnTdXyFBmajIpdtKsiV9u46sah1jnur/ZNWVs+YtS9TWzUBsSNmA6F1WLJOzvjl64O
         K46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550681; x=1793155481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NLzlKEOsCi9w1u4q3xRYee71IKEIz7iOlD+JfCxLSYE=;
        b=ty3rJqsEkskh477MiUcyJ/uECaY+jfjQveDVtE2i3169zxHVe3Rp2UR/kl0OhVt7gk
         X5azXOULQJokyyOg5KQZ811c9NVloi4aI8kVpYrrpWed6Yl/CMGoV89f9lDwwMS3GTY7
         SE/boZ1vl/0PIZerbEdO9epbZld41szylyzo87hBV0GNcwC7O/HTYukNtrhi6bXIDuYl
         2Vy1ZY7fL6xTGQnAJ4AkiIZEham5NwXrFkxiSBcUlHFl8ztz4tyJ1haGycVpN4gI0h8k
         BFVSRhfxyv37NefKsAgSAHt8P06TTY8dl0UScao2cXrBs7w1J5uSIm5MPt8zdaPsIYc1
         xovQ==
X-Gm-Message-State: AFq9FYLVGYZCxUzb5x8R5hd/9YgFt7zKdSJhIdf3VOAaPjLCp0yKblGh
	REv7RbQeMH3+E7mkxmgzh/QTv976jjyIz6OQWmHvHl+qpbvrqszObsCcCTs/j7vQBIq1jdzJhut
	97LTn
X-Gm-Gg: AYBFou2NJhLRTE+mcPw8+owOxuEvPJOIVADOrtQPdnId9N1udoJlZxxjDWVZWZMVeWx
	I3wJwcOHjGnniipvOBZUdvpL37gaSAh9opI3Me0fuGhQq7hDQyueK0b3hlpjRcFmaPHmkfv1eA7
	+K9D0ww+XOKGVfO+egxbu3DWGo+XBH2AAU8ycvgbYE02C5zs9TpcfxwykbouScPqWO67uat/W8G
	FWoCb9CckIDMkYTF9qs/Be2b8TAIKWlujSGVvpHZbMvuuBz3I7B0urv/WungHpZnIYM3eDZ9E8c
	KMfVJDOYLeTrH+EUv1L5NV5cgM3eECSR6QzPuiR+xfynx20b3hceeNS1rqE7hErc5Rg9R6Us962
	XPqdPEd7lfZVhX1bS69yUcrxXT1XH8jfd99OZ1dpDnPn1WopY9PYdMbPkyDNO3DbGBB4oFGKB7V
	RbCibbPWcOvl+SzgLptXwwC8w7pPxeOjP1mAOR21YmCmTgFO5v6WZ/spMJs6TDitBlYSmwZnH9s
	kmgg/Zs0eCx29zaY0NjMNjvAIvQ5fzg2ZSYISFk8grunwE5P12+GuiC1pRsi2NZLP6F7uo/qFNz
	JIaGDob8pM1CBrsW9Pt0/1iN3tHc7VDRnS1uERNwJA==
X-Received: by 2002:a05:620a:1a17:b0:939:c1d4:e2e1 with SMTP id af79cd13be357-93f57f0bd72mr216584085a.25.1792550680719;
        Tue, 20 Oct 2026 19:44:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56dd0022sm140259385a.20.2026.10.20.19.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:44:40 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	weixugc@google.com,
	aneesh.kumar@linux.ibm.com
Subject: [PATCH v2] mm/memory-tiers: reset demotion targets of nodes without memory
Date: Tue, 20 Oct 2026 22:44:38 -0400
Message-ID: <20261021024438.1942502-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h85qwa3qq8ebo3xkn4rs8u8d93dxpui8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DC44D20005
X-Rspam-User: 
X-HE-Tag: 1792550681-695306
X-HE-Meta: U2FsdGVkX19PnXn/so8JoMTMeGSkNYa1r138RmR9i1LPaIGjl/HaFuVUcxdkmv/zGns8r/WXRbk6z3WfjV6I4fbSvoeeoI6+nKarXNH03U3WPbK618Trd/daDmYbi4/BOwA7v9GvjpA4ZbnhXwiQybBjfMxQx6BFDJKHB9rRx0amP/qzK2ZF7V7zvYLV1M6p6GontbOf3GoD8miZMX+EgySDW7wQDHOH3tE1RNZRn/D+NMhWkVVqiC2m3ViChjdJ7lcrMehOaxPWoiq6Eqv8KyeJHZtvavF4Q/Y5nBwYcdJ/pQEZkyqzYLWwduMnrDB3fdNAbxrz6FPNd+kfsIH0GFURSNz4F7U1tq/ycVh+dx9q89KySeqwbB/OHYSY925sFA1Nbr/wOBFxmKKCPGYS6zlLCkl5XEHIISOD6htC+7gaUkHj72/wkkUlf0WXTX9Sd4i4Qwx3uowAxr/zscPJHGwyI2JOUXlUL2aGBShzyHUoI+X0gFqVZnOSEGCZw2ctmDcYnUj/eEjU3/KZTpDEoJQJiOk0tg9K/bbgvrhSaTFHTVdTY479h4kWMSNB4jf9zaFojbu3J8RewC9KAM4FwqzQsfsGAGSyzhjTLV9cyqGibFN5IsI+KRudJI9nC9Do2iIni80qdoqkbi6PyDO2t9eOpMs2ROa7QNZ/dorZTxTOlThatkuvNzpVmOdRE7XoeUQwNrQ5OmOR2BMAJPTykEWdD7aHK/jZD87h69gE8DGYVNZGchuR2GmEiqyMmY8dip8UfyU/f40ULCOna7YwXdaCrNuS7MUdowoen9KwZEviu280QXYrHUSOaK175kV4aXvOA9o6T0TWEQM0zFFY8GO8ZpMqZ/0D6W9neNf0Z3pqvVW0oD54lkSfWhLg6XGmqSA3IvZPA13iEqoLOqJWQVvBrwa8f5tHLbvGPeUJbxt0qluAtEubuqtq1UR+d9wTKcWFSIw/UoNPGjxu6wz
 HiUKCWmu
 wBq72zQ8JTnsJzBse4U555Q8tnOIdfj+Ls6LMWxwPbEd5WqLXxtYEO/V+ZQP2AplXjcUhy12+X5BKFeWVSEGlQSo/oL+jc8t7/2D+VZ9Pe2gxEh5SGeewvuBRDYR3zTiMrlfY7so6yRd7P75Hk4xsXZh06XCvt+M26HUevOMelh6YcDOSV6OSYGWQhP3x/qqVPrsE9gq2SiYZm4MK1HGQtIR/FdYRqVH80VlSkldG6dmEfQjX9CyywdongOQHKwcGNA4cQQuVrjCFtQomMEemxpMUsuJGA4L2lR90st6QpbI1QTm3y75q1vQy+bGdS9dK8mPfhiqQqFjJBV1YmzVD5ql/vFvXzFlWlplMY+amf3Fn1cWlMBfpq79RQEomdMuV42HA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a node loses its last memory, offline_pages() clears N_MEMORY
before the memory-tier callback rebuilds the demotion targets.
disable_all_demotion_targets() resets only N_MEMORY nodes, so the node
keeps its old node_demotion[] entry while it has no memory. Before
6c542ab75714, the reset covered every online node.

A reclaimer reads the stale entry only between the node regaining memory
and its targets being rebuilt, and it filters the entry against the
current allowed targets, so there is no user-visible effect. To see it,
online and then offline a node's only DIMM: a debugger still finds the
lower-tier node in node_demotion[nid].preferred.

Reset the targets of every node.

Fixes: 6c542ab75714 ("mm/demotion: build demotion targets based on explicit memory tiers")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
v2: +comment

 mm/memory-tiers.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b58..9d872404592e 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -378,7 +378,11 @@ static void disable_all_demotion_targets(void)
 	struct memory_tier *memtier;
 	int node;
 
-	for_each_node_state(node, N_MEMORY) {
+	/*
+	 * When the NODE_REMOVED_LAST_MEMORY event fires, N_MEMORY has already
+	 * been dropped from the node, so we must walk every node instead.
+	 */
+	for_each_node(node) {
 		node_demotion[node].preferred = NODE_MASK_NONE;
 		/*
 		 * We are holding memory_tier_lock, it is safe
-- 
2.56.0


