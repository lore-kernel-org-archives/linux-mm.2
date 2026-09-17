Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF3DC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78A66B00A1; Thu, 17 Sep 2026 10:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B268B6B00A2; Thu, 17 Sep 2026 10:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A2426B00A3; Thu, 17 Sep 2026 10:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69B186B00A1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D43D680365
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:24 +0000 (UTC)
X-FDA: 85223469408.04.C110880
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3C81C14000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbxk3B1k;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mozf9eR83klndQFJraTt18kHcl1hxd6yOHCmDoYKrX8=;
	b=O1g7Zdh8ZX3r7w/0tOhbzpYhCupeN+EUiiGikSeSRnZKWKWz0/stw8U2CociyX2ynKsBza
	8NDSbHj2u/kDIbeBOdn23QcZ4XycmRjZpLgfyHgu2hcoKlXbU/07OwZlzJCH+jLPi91F8o
	YOzmp59EZLs3X4ZQxuQBJwoJp5j9CQs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654943;
	b=4SW2Sy9+1uZUcuoOzH4HqQLLnVZMZ0tKWDOHj9JrH3C+u2VD0h7Qe274r+e6mvgh2Y47D/
	Q4ZkWhEpbC+HGdvKjcaX/sYHk2ZbGHyt6CXqM7boVcYz7WI5/0ZZQJkUkWh2sSESE/OjSS
	oV8FFputKUc+gAk86QmEBU2+g09QATc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbxk3B1k;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D9CD43D1E;
	Thu, 17 Sep 2026 14:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CD41F0089F;
	Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654942;
	bh=Mozf9eR83klndQFJraTt18kHcl1hxd6yOHCmDoYKrX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbxk3B1kVQa/Rmy2plmyyuHyctTxT8yCGXvhut/j2pz7uiz+QbAlLv8/6UztAXe41
	 tLJg8cKGIynm6fLnBghsnGt6GCd+jYC7M+RYUhe1vzhfTqX3dOZ4C1BId14gforUo+
	 Mpqj4T/S6kQMSBWZ180eQEfmNUJFLRFNss0AzQc3oQrGPO3n5O+L7sZsfgrNHslSA5
	 aGPofrVcWeRQSeyLDDMfGqp36KBQBcc2Kpb/M1Zuol0PY0FqPB/wrkDwU9zD5C7/EA
	 xT3EQzQInjk9Cx/S/7zF+BBGo6a7I5x/aPeqb6BVAs+d4FNyYRhwezk/i5o+sFkLYR
	 EPfhO8Oy0rVtA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 10/10] Docs/mm/damon/design: clarify bp is basis point
Date: Thu, 17 Sep 2026 07:22:08 -0700
Message-ID: <20260917142210.90829-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3C81C14000E
X-Stat-Signature: 7jaddswghnf79xpixxpu9ybi73ouj76p
X-Rspam-User: 
X-HE-Tag: 1789654943-87194
X-HE-Meta: U2FsdGVkX1+4H5zgcvriRSJLCGQNktY0pj1Q9HjtCmmAWb84kf3XEocVQ9L8aNFWtj6QLLFyOaMRS6+1+APFGy7Bn7dXmqgqL3HYWcMC0Hd5LDvU12f33jjRyjbAZi7kOLN15jyWS6NvQKEahn7w0kvwLfhwoBauXGt/LGx8DylmcxjSnDlY63S4N7xblajPUPsrBBilQWxywxo9W/in7u25237gJd2UMVqmiYnT693sqdyqM2IRs4Oq/DdlXyIwxEbbzB4nRjSxljWorIhetLhvgaQ6MOG6XgYgyJ/WTlWNWXoAo1Mu4o/3SkMu+0T4MCgyQKyK+l6bhzD5USFBDF67K1j7csQPmzV/j/Ulkjcz7SgnxsGVZdgGLd6JJ3eYHQLtK26AqGkK773QV677Xsn1Fhz3GMI4/rRSV1jGgbPncI13do4O0XhRBY34jpbJPnmXOuGASG+/kW5KJwaZ5aKtEv5BNEWWwS4Z17qM26dM4cYZ943yFUnYFnu7AZnUmMDqImhG6BlmAwUhe/A9RHZKazNgAyf7SQIMFifUggDi/B4WodgknqqvwDiToBesUDMkfSds4Q1QrPlq9VlEu1ipiv9ThaSJiTFciIDHKDastKEr27uY0ZMUs6Tws0T+8J6l7wRj6K5GebdXMTq1yfGzMbQZetWYVWEZtVZ/N77zc7FP63r0l/wEo7SRy2j6ResZIYMKRCI7cdiEMX5E/ww4GeUsFC0gaeU2U/RnFil96UEHlK7rEMSDJ35VhEDkQMWv5PWOm5jmcHw2GLpQFCllxGUXDl2m/9lbldLiuSbPE+qU8syGh8w3iwISLcusOBTuP93d5lLRhDf7WzMxBgEEsb5FXNUwtYjdJUeyf7zqYqOaX9F4ElwtJS2HFZwvfnfnVzeM1OyGZMaD1uWItJYeJgo4xvajrufXDCNSSicHGN/ls/7Yx4PecWjqO4KY9ieK2F66MF3lNlCqrcW
 xaCNFBqA
 HwiGKeLaTV0NDOAkctwlrdg2Mleramq1ZMU1rGixVhU2a0YwE37/9BU3+41NtebQnFTdiYd4/V59S6R3YbNF4IW7SMOuvvBImjos5JruFpq/2+bdtPQ1Jpc0Ax4RkKGHP9dEvJL7mEfYqmED7EgC/mcI89JLNdiXIR+ThCVbx/4ipVu+QfgMsyI+YIBCGN5q1StAWa36nHfvbI98edukgrlqohGe+CeRMuD6CzxDY7kUbMaadbPDQq2lA4QZFM6ucu6vpQmLsrWEm4pJi1lhWdPbpg+fiH5L6GS8gnf0afHNrfMA=
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

