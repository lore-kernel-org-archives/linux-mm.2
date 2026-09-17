Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF31C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD706B009F; Thu, 17 Sep 2026 00:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A50D6B00A0; Thu, 17 Sep 2026 00:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4AB6B00A1; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFA4B6B00A0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C8C840208
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:51 +0000 (UTC)
X-FDA: 85221915702.17.C1B8673
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E77C44000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhN2puzE;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617949;
	b=naTyaIvuHtMy45O5nkD0PSc3mOURDeVouwKetov/egD21th6mBh9O5+Njyl1RUn8TI60xf
	MVsMjQOl3e2woqOzGdfaLj5U/TcofosTfuO1sUu81nqNznK6L8ZABFiC9M4vT9uuTbaLw7
	jiclTUc3UtuL3IVTd5BLjVT8RW9dtxw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhN2puzE;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mozf9eR83klndQFJraTt18kHcl1hxd6yOHCmDoYKrX8=;
	b=u1dJzd15Jn07rxUZIn7E5eUcHXF0Y6J9BMYpEjAoIYQHoasG8uG1+HD9BFD3rkT9vN1Sbg
	a8v9VtlkGWWNx1/QcYCPx98rZxp5BLXn9jjC9rtDhgH83regehNK5+wJ/WVVfvebc/UY5g
	AJW+CvLn4EPHlNNh7Yn+vZ0y9XnazRI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9168160A5A;
	Thu, 17 Sep 2026 04:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48691F0089B;
	Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617949;
	bh=Mozf9eR83klndQFJraTt18kHcl1hxd6yOHCmDoYKrX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GhN2puzEsWiLv7s8wcGaPWWWFYfc1kACptDmFKSTdaoePt3/+GPX8BMMgRD3+GIKC
	 S4nfxqpdKNvJqtKASnnu/vk47kNDkTULgZCFUH0L7TowQXoA0A7UiFeWHBloVXRa5n
	 FrNaeF9cNUq3qq1RyAX1viVPh6HwjgiYC3VR/Ap4tkMhLfZ+3ufUSti61FyoU4JRDe
	 DX9CC8elLVbULwp0z+5LPeilDddi0plmtHLv+XK+GIVpP7jxItIuMB+t2UHOCRqDec
	 7raemiTAjfgKfRywm7kLR5JKOGzLnt1U9hDheawk4CluP8C5YojvSHQ9cnMtR/URik
	 V8rYQJKHyUPkg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 10/10] Docs/mm/damon/design: clarify bp is basis point
Date: Wed, 16 Sep 2026 21:05:36 -0700
Message-ID: <20260917040537.107341-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E77C44000B
X-Stat-Signature: hxggwz16aa7d3gfjxhm618gwfi7bhn8o
X-HE-Tag: 1789617949-498393
X-HE-Meta: U2FsdGVkX1/zTEvzFlqfh6yGziIB7aGuavmrlgmsnYO0NbkxlSaU3r3kXGeAX0aqnifkIx+oCtULJU9h+GX22oEmKsV1SXu/vC4An7xqdU3MavGHYUdUR4BcmHHV/UbRZEKrZLBj+iM5cMjbltu3VVKJZrV6t23UT/wk69ZRhYMQHsldFrLa5mOnrDKn1H0+iLwXikSO56/mGAxT1QR+Oevae3YCJb17/x+nuqOMdAL4fQ/qh9XUkOUm4z0fIZBEJEpZ4115zO4Xt9op/HHLcz4ikhkwj5kMhbQt41ggajYSvgJwd7YmS1C/U159RXStNAYNtvLVSgB61USbsgRcu8qW1j0C+tVAjuBFj4Pwoj2Ei3gyyQiC4s/ZmEijlDXVsRfxhvgvTKLhKK3zuqBfw/2zacWcvW1X+v4E9Tv5GGQH4xNC0ffbNT6WZ/3RyYcb3AuxRKJ4WFuo6kNc8QN3EzBfnQLDgLz3WGaJkROjayTTOCqlzcyjVsF8MZYJ6PAszv7uEsmTEIyWmTeJQttlq9z6wfFcIdHhaAZzh15llladyLM6UHg8XEYsbou9z1fUtcui19TMZkgtgFuOXUad5WQFBRM3iAXuHCF1jJy9zl+OCc/zwto6GDSxTWvSCzYlK2Ah6qtu0d/bt+6ILHJZrHKSo5u+eJRGOA3irZC65WMg42ir98wzVcGkXxuinrCDrfGtMQkBemb4Pf5jQLiCqjf9EXebCQSTP0vrl5ZKkjer83V4Io4YPJlCW+dAm0KMYwf5Ri6Hcopg7/714uvG5630I4vci3arhwTrCsDoeeuBRmceiuZVUTixpT7O+QFH+g2c/BdNY7BSJuf4koeCbagWfs336jy9HvjAo4LlxantSOdK3XfagIvPXJFfUm8F5eea3XMKXk7Jr9a3guFxuPmJ4GJOkKWlMxqStTfdC6r5RK07bVojbmxof4lSkyDOPE5j03c9Y3JeTz/w2J/
 DRrRPbii
 XLF72XlHJYmaHPmHZrxXTwbra/jSmoKyvxm1BlNj8E5o7mXAYG9dkOqNS93b7RUAt6kFF68WGYet9DyvqSiXZI3EN2TLqD7IvwaoJFdVF57OJUod4XcH5w2jBm/wsP7k39ukqxFNzqkTj1nP9htFLcsXs/8ovooL/g/g1N4YilRJO1WMiD2PsX2m46tb9O7q9Wos4AL9EO52tRuqnJEu26p2bMW0LrppFThxAb9a8jKlz4t9gdrrxrsmPnowImdHZ8SMQnaQqWMM/3y19a6vf1P0a+T7MoYzZwFyL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON design document uses "bp" for "basis point" in multiple places.
Because it is not clearly mentioned, it is difficult to understand what
"bp" stands for.  Add the clarification.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/107dc6ba-697e-4b25-ba3e-8ce2499cac9a@infradead.org
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 0a86792f90a18..e82390e77a70a 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -445,7 +445,7 @@ users to set the aimed amount of access events to observe via DAMON within
 given time interval.  The target can be specified by the user as a ratio of
 DAMON-observed access events to the theoretical maximum amount of the events
 (``access_bp``) that measured within a given number of aggregations
-(``aggrs``).
+(``aggrs``).  The ratio is in basis point (bp or 1/10,000).
 
 The DAMON-observed access events are calculated in byte granularity based on
 DAMON :ref:`region assumption <damon_design_region_based_sampling>`.  For
@@ -717,7 +717,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   in microseconds that measured from last quota reset to next quota reset.
   DAMOS does the measurement on its own, so only ``target_value`` need to be
   set by users at the initial time.  In other words, DAMOS does self-feedback.
-- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in bp (1/10,000).
+- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in basis point
+  (bp or 1/10,000).
 - ``node_mem_free_bp``: Specific NUMA node's free memory ratio in bp (1/10,000).
 - ``node_memcg_used_bp``: Specific cgroup's node used memory ratio for a
   specific NUMA node, in bp (1/10,000).
-- 
2.47.3

