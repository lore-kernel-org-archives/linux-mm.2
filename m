Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0BACDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7288F6B008A; Thu, 25 Jun 2026 10:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8E06B0092; Thu, 25 Jun 2026 10:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7986B0093; Thu, 25 Jun 2026 10:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3165C6B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6E4F14014C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:38 +0000 (UTC)
X-FDA: 84918655836.07.6717B21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 12AF2160007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJNNTNUN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397477;
	b=gqvN/IlQ+7hc19PR3jTT/0CFtDjVl5ga1Fbn1U9TaiTQ1rRDC/81Y4FAZlLmgaYn8on+1D
	ihNmDf2narE51+ELSiroK9tp5AS4zmI/bgUBR70slnoTCLUpR/NYmMeJlzLLxTwYp8/z3s
	rlNh9SxJBP8HZko8hNvUi9LPmR0T67Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZqcZeO9nNSHPkQcuZ0tph2LYz0rFmJSVYYnP0TkDSI=;
	b=ikWXhnUaGJxqNx2epYqrj7B84gAUFqE8oEZkZDK4Fjp3AGwtHa6x0PfPoc+6vlVvKSIBEe
	Bo0l8/ecJLlnb6KYpIfP4UZrpVmlq+ZIsk0/bRQqorW71M/6CWAYnDnSkXufd4BGh0INA0
	6KjtpOyjDfzozHKDyQJFX+AvZnudCyw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJNNTNUN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 326364046C;
	Thu, 25 Jun 2026 14:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578451F00A3D;
	Thu, 25 Jun 2026 14:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397476;
	bh=0ZqcZeO9nNSHPkQcuZ0tph2LYz0rFmJSVYYnP0TkDSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJNNTNUN2WnwnpZnBi0cCWrZ4IQnySWFA5U5S/yWC7ytYgQcC7fu9tgp0zY8/Pvld
	 3cbTwf1w1v+gaM7bc10spVuvhUl3fiyVzRskIpqcFDaaZ2PHX6ox1R5xmMeX2xZA5Q
	 QmzoPhN/e1HsOWXqdaRItKXqJC7uehez8nQPa9nU3mt0IzZzmVgOGe/nuWF1gT8Xl5
	 xcsbrnV9psTyQVOXDyIJwSPmOePfl6167h8mgqG9HpDpLQxllOrXVE5kvkdH9tB3BV
	 yKyibOthItlltAh06EHTnSUG3rVByaB/6/W5bXm7x/ji2Ewvz2HMGi0CIYsn660q+K
	 LPGqA+Lp0qAEw==
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
Subject: [RFC PATCH v1.2 01/11] Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
Date: Thu, 25 Jun 2026 07:23:46 -0700
Message-ID: <20260625142357.103500-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12AF2160007
X-Stat-Signature: bpb6judgpfru5w4utguhxsxtcr1rhjhj
X-HE-Tag: 1782397476-414974
X-HE-Meta: U2FsdGVkX19azVlmjzPAWwuZngZUiODWMe5R6ar4xx7YHOTGt9H8iip6NJRcr7hFTo7gseCZ0FGyWh4I0z/EahTu5sGexXkW77ijgJj13dEhKXOgWy4NrzKwV/mWyZc8eYgW5mpvdJKOW+UHDboH0PHVYeUZl82FIbkTjhq+lqlwHUnCmWlQFLOuzhYR1ycDbQOrdR2hGzWmdnge+yFjPQfhJ2oM7t/L2hKTIGhRaZPeV3QBQ4kQv1rOGuqyNThRQmsxqCuA0x5K7w3a2vZOvisf+sR/zX280CoGK5qWq4/7SlyI8qGPB0WoQy0ggXCpdWY0u5EZilpZS2uOTn/pbeSgniva4CFrukKd9COsR52/RsF7Stkqvc9Gg9NmeeKvsnL+1u7FXq9WhLK2ikzGj3ADWvq69ckBllaRAhLHd69hd38XenRe884J4XDhLmLmtgavXp1wQy1kclse6AljJHhU3HJhGrl38h3/NB79Mwfk4opTJEnMUR985CehBAbE0uuiHAX4Uz91g9ViCeA5MJ5Lb9JJQoad3sGZ0vbrQCWhSdvcdSczDlaJkh6vIrD7giTNTxokouvPqw7O4+cE5xUPJYGHpxFNfLkmvTXqxv9ZL4dq6gvxIqLLUTxifwrA6NdI6ZCGKqK9bVaLMsHfLGqWWAzKFKdv9Qc3IKa4MnUE/4jn2TNpjeNRhoVSSm6Ke/YvfyypN3NEYHuZPchWV46DfUsOnlwTcHrLzePX0cLFUff9jBlTHQuYneeknb/rqdhpWhR262doJDADIYIf3kZqS8kl8qzFaLzCmVLTYi3y7Xk0wfLilMAUV1LQ66y2xS3Gi3FBumV7SpXDgFFaS4Tp+jjSM3W9qIcmc2o1i4IHR1w2UAMJMlpH0WiRT7FGHY18sy6n4UppNn3gKqKCj/74FHqv1EQ2tjpLmG96Rj/4RvM68f+6Aq41zlHRHZvAij1t/GznvNOpR6H15+q
 yYaKzleW
 FIS9zsLu0E4fTuIY289Y6IcTfhSQRtx5y8CLoWJWdSYkSVi9BJTFaoDyOrWpp4MllQpYA3+ezAMB0qe7AQRupGR1I3rUNJXsIortY9jr2eqV3P6c7VXiRVSd4VGy8HHtL4AnDslt2NJUH4yfRNrc9C94J+mi0rk9rwfuiS2diznGFfXOQIufePlNfQk3ZEROqSiIpU5I+3VE3DEzg+CPGx+Gpjnloc9W8DcvVr9OU5Pt+7vYvLmm/IQChWo0FMDbL6Qhu2qGDK4AJUBi5gxX52psF5g1dNYL47xss
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
 Documentation/mm/damon/design.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2da7ca0d3d17a..9dbace087a329 100644
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
+``node_memcg_used_bp`,` ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
 point the specific NUMA node.
 
 ``path`` is optionally required for only ``node_memcg_used_bp`` and
-- 
2.47.3

