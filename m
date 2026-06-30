Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC71C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189BC6B00D3; Tue, 30 Jun 2026 10:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0772A6B00D4; Tue, 30 Jun 2026 10:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD29F6B00D6; Tue, 30 Jun 2026 10:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 975B76B00D3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F02B6167D68
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:39 +0000 (UTC)
X-FDA: 84936782238.25.F011009
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6AA6D80003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N1l/BLxf";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829058;
	b=bP75OtV8BpiB+LAtlNsq25QGkueqcVIrRGbuE33FJxABGr4mBZnZ20sgNT1wW8v1T2EiW5
	a3rpUWm7OcHgFIk9Nt0rmy+dVr0JuKmCUmPLjjRdKOAe8F9dmtcVaab2VEhEkzl5ftjefu
	6JkzxI3CnWMD+ToTz3PSOVH9g4NwrQo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaWgesU8aN91zn7rMZBQxRvubXirh78uhNh4ITz88u0=;
	b=ia6Rzw7dmwAnDLjEEtJWc+1/0oC3/gTwF5R0JmHhfNtmETrto8F2cgZJQC5DEWgLGQ59Ha
	Uudzec+4oRYFagg+0W7rSNd8dIdh9zisz483vHhT7y1HWtSeDjdhdeIVAjTODQXafQLcM4
	OFThiGEZ1L7vijKTywHxXH5wJKMGM0o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N1l/BLxf";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3FE1601C1;
	Tue, 30 Jun 2026 14:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8FC1F00A3A;
	Tue, 30 Jun 2026 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829057;
	bh=EaWgesU8aN91zn7rMZBQxRvubXirh78uhNh4ITz88u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1l/BLxfWBSL1GHQHAM4VeBefwfWJ8DUwHFDZk9rISZ9EwN9zyi+6mdvH3mtclzb7
	 uLysxyP3jWwlFFvK5MkMp/MNfMcq9ugonQBYpHS8GwdnZZViPRbydI7GKWxSjHYEt1
	 bfj0u4RgNUCwGEiHG8LT7D4l/SrzSnWTT4gvIEruPG3OuIiER+VDzRlcwqWJzcd2tT
	 UKVP3IWV0MhrlBTHlYW6t1UwFC8iYBCvJJpY2VDmYPgIpbMk22yvvOlENQLYwYWxQh
	 4RHrVTrjejJsrrXfaib5LM4Ew9d+rOJzZHYzIzgkJEvpCezbn/mQd0plHMtRELpB6Q
	 Kuh0ykO8XKrxg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/11] Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
Date: Tue, 30 Jun 2026 07:17:15 -0700
Message-ID: <20260630141726.92246-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mxay8pzj8zehm8wosuz753faary5ztt5
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AA6D80003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782829058-299731
X-HE-Meta: U2FsdGVkX18uJuDqYKHE28K6zcueLQkBXk6CDbFqqQeXniGhX2spD6pDpszBASwAj/i9XelJV5wLlF2WVN+KCd13vsijg6L4IbSEs+Ozr5ZAm1892vi15IlA6ufyrpgApnMtyRu4kGOVLepjZJhzD7eLUgqK9MndeJi37vgvxR9DbBSNoEtmPHnttWiOGdXgmKMmmplkMEC41izdueqcxdc/RHIj1O+LA071DejAKFG22c/BcZHUWx5Zx1AwJgnc97eaWiKgpTfHoxzhzoCbQ4Bqh/PgxtuFXNmLjIAYU9rhhk/rCotjOZEwhGrryVduip2Z+ng8rIbgFftuMEjyeFe3j1SATE9dxqXlixVXc2ELfosWiP56aV/Hq6ZlOfiByTanYwKf9rTXqc/D/xHGSxXr4pI2i93EwNii+7pkU9o+zHY8dOmqyH+0yWy82n2L+v9JIkrnI3/iSl7MUxc2PIZodQNnPxsENu2skJRBYN9zrn1hiidQLpnRWwww2xdOXyAoC/qLdIruonTZBPveDz9Oo+Bhze7Hgwkve95qyEaOwmsWYumGsnP/4sfNjlUprltHGEj3FddsWBcmp9I/k+TIz8sQkd+J2KYkIhfnLClSKMzMmPTuuj8njWqDQfZT3mGWVeepbg/lW41aHS61df9r+tlRxoiPDyKFKmSq6Fl6L4r6lG0/9u0JEgBr/YcurEAgZ4deabglpL6OHz3JNyztBePBBLq3iUBJ81Cs2gQpmXAGRW39ot1cPkuGzgyTrR/VaE53f7tcjsNbE5jtX8rZnQDsTa+jcrUYhemFNEc7SkVtAEerkDJy9liPgz0VAKsFg9j0cMooEkUEnJnZVoFNntss/cCXnjMC33lUNnJGV07Ud+eeXQvrfVhRrInofmcuMKVuJoKi+yORALHGxqVpwGKJQA3LrGC6lmlv0JuC3RExs8Nqhfw+jcHW+8dBEdjWB2we9B8sF/M8nzE
 zCjFi/8b
 gCS7J9ZF+1n2fxF1etH/J22gLxlc0epeSqbYJdUIK+pIiGv1fh+hrdct8ctT9VfZ2SD1B7vmlzXUBqe9pw97EF/MnZUVxP9XBNWxwS0BIRA7fib8+yw2/MRIZAwyruzYxqXLXL74iJHoKDw2HPZp5pNBQzQBIdS2rKn8VX+aoTTZbXzq4g2w7/3/VkY6qIBah8RG592W4T1W1vl7wLaemtEEFFB4L5QocWTC3gD13ZQDQhuDFoZRXuVKNx2NEu9rnUDVvb/KBTxnqSWmWfwlXjvMQGDKrgwS+o7Xc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
introduced DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP but forgot updating the
DAMON design document for that.  Update.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index c16a3bb288d07..457d6e8bc7878 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -686,9 +686,11 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   (1/10,000).
 - ``inactive_mem_bp``: Inactive to active + inactive (LRU) memory size ratio in
   bp (1/10,000).
+- ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
+  of a node in bp (1/10,000).
 
-``nid`` is optionally required for only ``node_mem_used_bp``,
-``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
+``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
+``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
 point the specific NUMA node.
 
 ``path`` is optionally required for only ``node_memcg_used_bp`` and
-- 
2.47.3

