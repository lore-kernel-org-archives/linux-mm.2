Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAC71CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFBD6B0098; Wed, 24 Jun 2026 10:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A692C6B0099; Wed, 24 Jun 2026 10:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980276B009B; Wed, 24 Jun 2026 10:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9866B0098
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA64A4033F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:24 +0000 (UTC)
X-FDA: 84915016368.14.6F2C383
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 503FF40016
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kh6CQIWs;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310823;
	b=LyVAa5+WBBEe2KUWz2VueLU5q4a5+hZGMenDJLZPq3Py8UqpOjyyXO/fK306QO5lZDsw9J
	XS/q9UCDZwcgNPzJthQtpk7hqArxvpUOyz5TrJp907t3oesBpwKeMPJgX42feBx+4hynww
	WndS3yd9q6RybZm8kU4SDUvpxdZ/yIU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVCNJtOfFO7pgjJRgMMYuUjN3efzSxhou1ebWwN/K3Y=;
	b=VNM4ahJ8FZjyUKQM/e5MGam7qEoQEuW8zcCE9xKXq+H/dPIzoZFC1tXZfcqOnq1pH6ismp
	W3BuVSaFJ2RYoqAjAZH2c55GhujYzCyeEP0qJpJLvgyirGza85nhYdtdwuNjTbwqVPLbI5
	4UJIOSp9xXKN3er90fKwi7o4IFZNwPY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kh6CQIWs;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AA344410E;
	Wed, 24 Jun 2026 14:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65B01F00A3F;
	Wed, 24 Jun 2026 14:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310822;
	bh=bVCNJtOfFO7pgjJRgMMYuUjN3efzSxhou1ebWwN/K3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kh6CQIWsn5SlNK8IOKr/guTrM5zSpZkmFsTQ0V/Cw6eKAQ7kVT68FgVB/juYYOtoe
	 F4amM0Rk2JJlKnXnLsEXfeT6mP7JaZH8zm5cB8bDAy3tJXCb3SQME/bNmxb5hasx/L
	 /xIyXqihYrcXhQri41ghvb8fipoLnHevOMWW4FCAYQ89sUqA/foZ1BbwftEGntDQH3
	 N0aUIY5OYeDa/seXBcd6EjPaADedH/YHaiSe1QHZnHH/Vm046VwHhnXQ2TxNdXBV+7
	 ueV7y3Loajnn9yjMwWByz3eh6GgS6BS2AQywLMuOtTtNFiH4W3uUI+pJySjcPgprGF
	 IZ+eENDWK8zzg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH 01/11] Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
Date: Wed, 24 Jun 2026 07:19:57 -0700
Message-ID: <20260624142008.87180-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 503FF40016
X-Stat-Signature: 7afts7bnj5jf87pq7fo5yw9jgkm1w7um
X-HE-Tag: 1782310823-665220
X-HE-Meta: U2FsdGVkX19v8yeK2A3/i276KznE/WfkCWe0L4WxMIq7UcAkFimJUflrJlVRh+qalguR5uY0HG1ttky9VBE9nyzVvjLzB1Gx9LUvYs9M9P6JG0+lrqH/ReH9ZGRIQHrxcVkhXHxPOQCxMfyceP+VBwUlINeW0SZ+/t1k/Ezw1kJf+rwyiL0DmdKr+iZSxBRLmcXxbaC9zs7OACFob+qfFCj/dqFpW+MfioIAslclR2Y7ofQ7t2QCow22B+xX4Jz6muGhGrjQG6UmkP5hNyo4GHLMVIXRHAT3vD53i4rSzS4OOJRHZN+3pjQ7LNJfJhaGWYM0w1IELHLcpYAX+FFQjuRZz4IDO7lYduysOTSUEpwxcnnsKAc48lQ6Bwpj0fXW7aiHKssM3/QvF3bWdletrvS00uqfVQf4BL723Sv4dfcSb4ndczxHj2A5yxKSXHqAukcY2HWhJiw8UDs/xU0aCd//Gkm28xRRm9ZWeaQNx+780iVjGMdkKzDb1YTzFljImB3KL0VsvTePpSP58i1/yYYTRbaqTH93A3x16Rr8MkVbhfYjHTGbLGMNW8AsL+3GQ1JVQhPHCALPHO82z2qXvPZznzD2tvwoMb41r6gYQj2PUkTo+c9i56Sdhc10bpDdSX0uc6pFTqQycRcYSBAYC5OnIc65mpCGH5lHT9f/sEBznhh9f0DQQyJtfrsuOcee4g6hdz9ApjZq7n++liN+zHFsI/s7u6qivarpteuaiyrxyf5RsMddsiN/ASdwFjbrsxg+vIPKeJnucKSvvVg7YlrMtFfHyRXtAW0e1P4agYTPBdi5TJHXUPlgSYbJNGnoZ5xeWGEymeTbu92ZdTUvj29BdkzrJWKGlLSx1g3ceGSVkoeQxuK6HCc8csHGlGxEuxZjqo7uF4mQZ+ty1n2TbkfIVf5SQBlsm1oVVb3SeJTmldyUrTbNW4tfevQ0sSCoVO/P5Iraqy8nvzwrqzb
 KXIbeAol
 9GGgD3/YpNbhzh4AWj8gTLEIJ7mQZb9P7V5VXWqVVOmpcbL2QRkLh6mSVfWKXy+ul+pGc1+QeaszVEYvgKoXWCcJOzQYVXY2fUyNYYEw+2zkwWQ7QGjJGl4oLAwZMgujhUmgVZggUJ+FD+U3Ufh3s/xk+72fciGVYtGPEsM5XlyslkbmdRYqWZ9EzENUmjQkZGbOZuFPLx0Jhi8l5QN0MkHfn9ZWp5LtB8wscxOgIF5tHJyJk79Mg+xM1YrqJF81IiBD+t5PQ45zJjtv+fZ38fOF6Z9eoR5uhXL8MgrCSC1PsJWtdbxAXZzsANQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
introduced DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP but forgot updating the
DAMON design document for that.  Update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index c16a3bb288d07..06a8894eb06f9 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -686,6 +686,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   (1/10,000).
 - ``inactive_mem_bp``: Inactive to active + inactive (LRU) memory size ratio in
   bp (1/10,000).
+- ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
+  of a node in bp (1/10,000).
 
 ``nid`` is optionally required for only ``node_mem_used_bp``,
 ``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
-- 
2.47.3

